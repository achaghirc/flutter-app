import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/presentation/providers/theme_provider.dart';

class CreditCardCreateWidget extends ConsumerStatefulWidget {
  const CreditCardCreateWidget({super.key});

  @override
  ConsumerState<CreditCardCreateWidget> createState() => _CreditCardCreateWidgetState();
}

class _CreditCardCreateWidgetState extends ConsumerState<CreditCardCreateWidget> {
  late bool isDarkTheme;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = true;
  bool useFloatingAnimation = true;
  @override
  void initState() {
    super.initState();
    isDarkTheme = ref.read(themeNotifierProvider).isDarkMode;
  }
  
  
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Glassmorphism? _getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return isDarkTheme
        ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
        : Glassmorphism.defaultConfig();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      print('valid!');
    } else {
      print('invalid!');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            CreditCardWidget(
              enableFloatingCard: useFloatingAnimation,
              glassmorphismConfig: _getGlassmorphismConfig(),
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              bankName: 'Axis Bank',
              frontCardBorder: useGlassMorphism
                ? null
                : Border.all(color: Colors.grey),
              backCardBorder: useGlassMorphism 
                ? null 
                : Border.all(color: Colors.grey),
            showBackView: isCvvFocused,
            obscureCardNumber: true,
            obscureCardCvv: true,
            isHolderNameVisible: true,
            labelCardHolder: 'TITULAR DE LA TARJETA',
            labelValidThru: 'VALIDA\nHASTA',
            cardBgColor: Theme.of(context).colorScheme.background,
            backgroundImage: 'assets/card_icons/card_bg_world_map.png',
            isSwipeGestureEnabled: true,
            onCreditCardWidgetChange:
              (CreditCardBrand creditCardBrand) {},
              customCardTypeIcons: <CustomCardTypeIcon>[
                CustomCardTypeIcon(
                  cardType: CardType.mastercard,
                  cardImage: Image.asset(
                    'assets/card_icons/mastercard.png',
                    height: 48,
                    width: 48,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber, 
                      cvvCode: cvvCode,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardHolderName: cardHolderName, 
                      expiryDate: expiryDate, 
                      inputConfiguration: InputConfiguration(
                        cardNumberDecoration: InputDecoration(
                          focusColor: Theme.of(context).colorScheme.secondary,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelStyle: GoogleFonts.nunito(
                            color: Theme.of(context).colorScheme.onBackground
                          ),
                          labelText: 'Número de la tarjeta',
                          hintText: 'XXXX XXXX XXXX XXXX'
                        ),
                        expiryDateDecoration: InputDecoration(
                          focusColor: Theme.of(context).colorScheme.secondary,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelStyle: GoogleFonts.nunito(
                            color: Theme.of(context).colorScheme.onBackground
                          ),
                          labelText: 'Fecha de caducidad',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          focusColor: Theme.of(context).colorScheme.secondary,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelStyle: GoogleFonts.nunito(
                            color: Theme.of(context).colorScheme.onBackground
                          ),
                          labelText: 'CVV',
                          hintText: 'XXX'
                        ),
                        cardHolderDecoration: InputDecoration(
                          focusColor: Theme.of(context).colorScheme.secondary,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelStyle: GoogleFonts.nunito(
                            color: Theme.of(context).colorScheme.onBackground
                          ),
                          labelText: 'Titular de la cuenta'
                        )
                      ),
                      onCreditCardModelChange: onCreditCardModelChange, 
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _onValidate,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        padding:
                            const EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        child: Text(
                          'VALIDATE',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
}

