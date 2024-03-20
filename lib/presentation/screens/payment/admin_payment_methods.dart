import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/stripe/account/account_dto.dart';
import 'package:my_app/infraestructure/repositories/stripe/stripe_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/shared/form/form_layout.dart';
import 'package:my_app/shared/widgets/bottomSheet/bottom_sheet_widget.dart';
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';
import 'package:my_app/shared/widgets/snackBar/custom_snackbar_widget.dart';


class AdminPaymentMethods extends ConsumerStatefulWidget {
  const AdminPaymentMethods({
    super.key,
  });

  @override
  ConsumerState<AdminPaymentMethods> createState() => _AdminPaymentMethodsState();
}

class _AdminPaymentMethodsState extends ConsumerState<AdminPaymentMethods> {
  late JwtAuthenticationResponseDTO session;
  late bool showAddAccount = true;
  @override
  void initState() {
    super.initState();
    if(ref.read(sessionProvider).session == null){
      context.pushReplacementNamed('signin');
    }
    session = ref.read(sessionProvider).session!;
  }

  

  Future<List<Account>> getBankAccounts() async{
    List<Account> account = await StripeRepositoryImpl(session).retrieveAccounts(session.user.id);
    if(account.isNotEmpty){
      setState(() {
        showAddAccount = false;
      });
    }
    return account;
  }

  Future<void> deleteAccount() async {
    try{
      String res = await StripeRepositoryImpl(session).deleteAccount(session.user.id);
      if(res != 'OK' && mounted){
        CustomSnackBarWidget.openSnackBar(context, 'Error', 'La cuenta no se ha podido eliminar.');
      }
      if(res == 'OK' && mounted){
        CustomSnackBarWidget.openSnackBar(context, 'Sucess', 'La cuenta se ha eliminado correctamente.');
      }
    }on Exception catch(e){
      if(mounted){
        CustomSnackBarWidget.openSnackBar(context, 'Error', 'Ha ocurrido un problema eliminando la cuenta.');
      }
      if(kDebugMode){
        print(e);
      }
    }
    
  }
  Future<void> _collectAccount() async {
    // Precondition:
    // 1. Make sure to create a financial connection session on the backend and
    // forward the client secret of the session to the app.
    try {
      await StripeRepositoryImpl(session).createOrRetrieveCustomer(session.user.id);
      await StripeRepositoryImpl(session).createAccount(session.user.personEmail, "");
      final financialSession = await StripeRepositoryImpl(session).retrieveSessionClientSecret(session.user.id);
      final clientSecret = financialSession.clientSecret;
      // 2. use the client secret to confirm the payment and handle the result.
      
      final result = await Stripe.instance.collectFinancialConnectionsAccounts(
        clientSecret: clientSecret,
      );
      if(mounted){
        context.pop();
        CustomSnackBarWidget.openSnackBar(context, 'Success', 'Data collected correctly: ${result.
        toString()}');
      }
    } on Exception catch (e) {
      if (e is StripeException && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unforeseen error: ${e}'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tus Cuentas',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w700
          ),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: getBankAccounts(), 
            builder: (context, AsyncSnapshot snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData){
                return const Center(child: CircularProgressIndicator());
              } else if(snapshot.data == null) {
                return Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'No tienes ninguna cuenta bancaria configurada.\nAñade la primera.',
                    style: GoogleFonts.nunito(
                      color: Theme.of(context).colorScheme.onBackground
                    ),
                    
                  ),
                );
              } 
              else {
                List<Account> accounts = snapshot.data as List<Account>;
                if(accounts.isEmpty){
                  return Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'No tienes ninguna cuenta bancaria configurada.\nAñade la primera.',
                      style: GoogleFonts.nunito(
                        color: Theme.of(context).colorScheme.onBackground
                      ),
                    ),
                  );
                }
                return _BankAccountWidget(
                  account: accounts.first, 
                  session: session, 
                  deleteAccount: deleteAccount
                );
              }
            }
          ),
          showAddAccount ? Positioned(
            bottom: MediaQuery.of(context).size.height * 0.03,
            right: MediaQuery.of(context).size.width * 0.04,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15)
              ),
              onPressed: (){
                //_collectAccount();
                //_createBankAccount();
                BottomSheetWidget.showModalBottomSheet(
                  context, 
                  _CreateBanckAccount(session: session), 
                  MediaQuery.of(context).size.height * 0.5, 
                  MediaQuery.of(context).size.height * 0.5, 
                  null, null);
                
              },
              child: Icon(
                Icons.add_card_outlined,
                color: Theme.of(context).colorScheme.background,
              )
            ),
          ) : const SizedBox(),
          
        ],
      ),
    );
  }
}


class _BankAccountWidget extends StatelessWidget {
  final Account account;
  final JwtAuthenticationResponseDTO session;
  final Function deleteAccount;
  const _BankAccountWidget({
    required this.account,
    required this.session,
    required this.deleteAccount
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (account.externalAccounts.data.isEmpty) ?
            InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {},
              child: ListTile(
                title: Text(
                  'Configura tu cuenta',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).buttonTheme.colorScheme!.primary
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_outlined),
              ),
            )
          :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${account.externalAccounts.data.first['bank_name']}',
                style: GoogleFonts.nunito(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: Text(
                  account.country,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ]
          ),
          Divider(
            indent: MediaQuery.of(context).size.width * 0.005,
            endIndent: MediaQuery.of(context).size.width * 0.005,
            height: 10
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0,0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Titular de la cuenta:',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  account.externalAccounts.data.first['account_holder_name'],
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0,0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email:',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  account.email,
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0,0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cuenta:',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  account.externalAccounts.data.isEmpty ? '-' :'ES** **** **** ** ******${account.externalAccounts.data.first['last4']}',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
          ),
          Divider(
            indent: MediaQuery.of(context).size.width * 0.005,
            endIndent: MediaQuery.of(context).size.width * 0.005,
            height: 10
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
              title: Text(
                'Transferencias',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              trailing: Switch(
                value: account.capabilities.transfers == 'active',
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey,
                thumbIcon: MaterialStateProperty.resolveWith((states) => account.capabilities.transfers == 'active' ? const Icon(Icons.check_outlined, color: Colors.white) : null),
                activeColor: Colors.greenAccent,
                activeTrackColor: Colors.grey,
                onChanged: (bool value) {
                  
                },
              ),
          ),const SizedBox(
            height: 10,
          ),
          ListTile(
              title: Text(
                'Pagos con tarjeta',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              trailing: Switch(
                value: account.capabilities.cardPayments == 'active',
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey,
                thumbIcon: MaterialStateProperty.resolveWith((states) => account.capabilities.cardPayments == 'active' ? const Icon(Icons.check_outlined, color: Colors.white) : null),
                activeColor: Colors.greenAccent,
                activeTrackColor: Colors.grey,
                onChanged: (bool value) {
                  
                },
              ),
          ),
          Divider(
            indent: MediaQuery.of(context).size.width * 0.005,
            endIndent: MediaQuery.of(context).size.width * 0.005,
            height: 10
          ),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              BottomSheetWidget.showDialogCenter(context, _DialogDeleteAccount(deleteAccount: deleteAccount));
            },
            child: ListTile(
              title: Text(
                'Eliminar Cuenta',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).buttonTheme.colorScheme!.primary
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
class _DialogDeleteAccount extends StatelessWidget {
  final Function deleteAccount;
  const _DialogDeleteAccount({
    super.key,
    required this.deleteAccount
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          'Eliminar Cuenta',
          style: GoogleFonts.nunito(),
        ),
        content: Text(
          '¿Estas seguro de que quieres eliminar esta cuenta?',
          style: GoogleFonts.nunito()
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancelar')),
          FilledButton(onPressed: () => deleteAccount(), child: const Text('Sí'))
        ],
      );
  }
}


class _CreateBanckAccount extends StatefulWidget {
  final JwtAuthenticationResponseDTO session;
  const _CreateBanckAccount({
    super.key,
    required this.session
  });

  @override
  State<_CreateBanckAccount> createState() => _CreateBanckAccountState();
}

class _CreateBanckAccountState extends State<_CreateBanckAccount> {
  final _fbKey = GlobalKey<FormState>();
  late JwtAuthenticationResponseDTO _session;
  final bool _autovalidate = false;
  bool showEmailError = false;
  final TextEditingController _ibanController = TextEditingController(); 
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _accountHolderName = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _session = widget.session;
  }

  Future<void> _createBankAccount() async {
    try {
      String token = "";
      BankAccountTokenParams params = BankAccountTokenParams(
        accountNumber: '000123456789',
        routingNumber: '110000000',
        country: 'US', 
        currency: 'usd',
        type: TokenType.BankAccount,
        accountHolderType: BankAccountHolderType.Company,
        accountHolderName: _accountHolderName.text
      );
      Stripe.instance.createToken(CreateTokenParams.bankAccount(params: params)).then((value) => {
        print(value),
        token = value.id,
        StripeRepositoryImpl(_session).createAccount(_session.user.personEmail, token)
      });
      return Future.delayed(const Duration(milliseconds: 1));
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          horizontalTitleGap: MediaQuery.of(context).size.height * (-0.15),
          title: const TextIconWidget(size: 55),
          trailing: IconButton(
            onPressed: (){
              context.pop();
            },
            icon: const Icon(
              Icons.close_outlined
            ),
          ),
        ),
        Column(
          children: [
            Form(
              key: _fbKey,
              autovalidateMode: _autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
              child: FormLayout(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _ibanController,
                      onChanged: (val) {
                        _ibanController.text.trim();
                      },
                      validator: (value) {
                          if(value == ''){
                            return 'Iban obligatorio';
                          }
                          if(!RegExp(r'([a-zA-Z]{2})\s*\t*(\d{2})\s*\t*(\d{4})\s*\t*(\d{4})\s*\t*(\d{2})\s*\t*(\d{10})').hasMatch(value!)){
                            return 'Formato de IBAN inválido';
                          }
                          return null;
                      },
                      
                      decoration: InputDecoration(
                        focusColor: Theme.of(context).colorScheme.secondary,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                        )),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'IBAN',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.onBackground
                        ),
                        hintText: 'ESXX XXXX XXXX XX XXXXXXXXXX'                    
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _accountHolderName,
                      onChanged: (val) {
                        _fbKey.currentState!.validate();                      
                      },
                      validator: (value) {
                        if(value == null){
                          return "Campo obligatorio inválido";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        focusColor: Theme.of(context).colorScheme.secondary,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Titular de la cuenta',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.onBackground
                        ),
                        hintText: 'Nombre Apellido Apellido'
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          label: Text(
                            'Guardar',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primary
                          ),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,  
                          ),
                          onPressed: () {
                            //_collectAccount(context);
                            if(_fbKey.currentState!.validate()){
                              _createBankAccount();
                            }
                          }
                        ),
                      ),
                    ),
                  ),

                ]
              )
            )
          ],
        )
      ],
    );
  }
}