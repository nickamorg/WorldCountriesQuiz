import 'package:flutter/material.dart';
import 'package:worldcountriesquiz/AppTheme.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ContactScreen extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		return ContactWidget();
	}
}

class ContactState extends State<ContactWidget> {
	final TextEditingController ctrlField = TextEditingController();

  	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
                centerTitle: true,
				backgroundColor: AppTheme.MAIN_COLOR,
				title: Text('Suggestion')
			),
			body: formWidget()
        );
	}

    Form formWidget() {
        final formKey = GlobalKey<FormState>();
        final List<Widget> widgets = [];

        bool validateProposals() {
            return ctrlField.text.isEmpty;
        }

        sendEmail() async {
            final Email email = Email(
                body: '${ctrlField.text}\n',
                subject: 'World Countries Quiz: Proposals',
                recipients: ['zirconworks@gmail.com'],
                isHTML: false,
            );

            await FlutterEmailSender.send(email);
        }

        widgets.add(
            Card(
                child: Padding(
					padding: const EdgeInsets.all(10),
					child: Text(
                        'Did you find any quite easy or too hard quiz? Tell us about it!\n\nWe are always looking for new, balanced and not only more educating but also challenging content.',
                        style: TextStyle(
                            fontSize: 20
                        ),
                    )
				)
            )
        );

        widgets.add(
            Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: TextFormField(
                    minLines: 3,
                    maxLines: 6,
                    controller: ctrlField,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide()
                        ),
                        hintText: 'Type something...'
                    ),
                    validator: (value) {
                        if (validateProposals()) {
                            return 'Field is required';
                        }
                        return null;
                    }
                )
            )
        );

        widgets.add(
            Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                            if (formKey.currentState!.validate()) {
                                sendEmail();
                            }
                        },
                        child: Text('Send Email', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            primary: AppTheme.MAIN_COLOR,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(width: 0, style: BorderStyle.none),
                                borderRadius: BorderRadius.circular(10)
                            )
                        )
                    )
                )
            )
        );
        
        return Form(
            key: formKey,
            child: Padding(
                padding: EdgeInsets.all(30),
                child: ListView(
					shrinkWrap: true,
                    children: widgets
                )
            )
        );
    }
}

class ContactWidget extends StatefulWidget {

	@override
	State createState() => ContactState();
}