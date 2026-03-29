import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InviteItem extends StatelessWidget {
  const InviteItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
          ),
          child: ListTile(
            leading: const Icon(Icons.group_add, color: Colors.deepPurple),
            title: Text(
              AppLocalizations.of(context)!.inviteFriends,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.inviteSubtitle,
              style: TextStyle(color: Colors.purple[900]),
            ),
            onTap: () {
              //TODO: share item
            },
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 60,
          height: 1,
        ),
      ],
    );
  }
}
