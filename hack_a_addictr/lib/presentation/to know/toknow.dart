import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:punarjani/theme/theme.dart';

class Toknow extends StatelessWidget {
  const Toknow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeprovider, _) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              color: themeprovider.themeData.brightness == Brightness.dark
                  ? const Color(0xFFEAE0C8)
                  : const Color(0xFFFF4400),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
                    child: Image(
                      image: AssetImage('assets/ncb.jpg'),
                      height: 50,
                      width: 50,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('DRUG LAWS IN INDIA',
                      style: TextStyle(
                          color: themeprovider.themeData.brightness !=
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 23,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: themeprovider.themeData.brightness != Brightness.dark
                    ? const Color(0xFFEAE0C8)
                    : const Color(0xFFFF4400),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    'Narcotic Drugs and Psychotropic Substances Act (NDPS), 1985: This is the main law governing drug-related offenses in India. It prohibits the production, manufacture, possession, sale, purchase, transport, and consumption of narcotic drugs and psychotropic substances, except for medical or scientific purposes2.Punishments: The severity of the punishment depends on the quantity of the drug:Small Quantity: Up to 6 months imprisonment or a fine up to ₹10,000, or both.More than Small but Less than Commercial Quantity: Up to 10 years imprisonment and a fine up to ₹1,00,000.Commercial Quantity: 10 to 20 years imprisonment and a fine up to ₹2,00,000.Exceptions: Drugs used for medical or scientific purposes are regulated by the government. For example, certain drugs like cannabis and opium can be used for medicinal purposes under strict regulations.Enforcement: The Narcotics Control Bureau (NCB) is responsible for enforcing drug laws and combating drug trafficking in India.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      height: 2,
                      color:
                          themeprovider.themeData.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
