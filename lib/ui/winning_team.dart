import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:team_wins/data_models.dart';
import 'package:team_wins/ui/winning_team_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WinningTeam extends StatefulWidget {
  final int competitionId;
  const WinningTeam({Key? key, required this.competitionId}) : super(key: key);

  @override
  _WinningTeamState createState() => _WinningTeamState();
}

class _WinningTeamState extends State<WinningTeam> {
  @override
  Widget build(BuildContext context) {
    const horizontalBP = 1000;
    final mediaSize = MediaQuery.of(context).size;
    final shouldBreak = ((mediaSize.width / mediaSize.height) > (4 / 3) &&
            mediaSize.width > 200) ||
        mediaSize.width > horizontalBP;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Container(
          constraints: BoxConstraints(minHeight: 400).loosen(),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0x28CCCCCC),
                blurRadius: 12,
                spreadRadius: 1,
                offset: Offset(1, 2),
              )
            ],
          ),
          child: Consumer(
            builder: (context, watch, child) {
              final winningTeam =
                  watch(winningTeamProvider(widget.competitionId));
              return winningTeam.when(
                loading: () =>
                    Center(child: CircularProgressIndicator.adaptive()),
                error: (e, s) {
                  return Center(child: Text("An error occurred"));
                },
                data: (team) => Flex(
                  direction: shouldBreak ? Axis.horizontal : Axis.vertical,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: shouldBreak
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    Flexible(child: TeamBaseDataWidget(team: team)),
                    SizedBox(height: 20, width: 20),
                    Flexible(
                      child: SquadDetails(squad: team.squad!),
                      flex: 3,
                      fit: FlexFit.loose,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SquadDetails extends StatelessWidget {
  final List<SquadMember> squad;

  const SquadDetails({
    Key? key,
    required this.squad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Squad",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(builder: (context, constraints) {
          return GridView.builder(
            primary: false,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (constraints.maxWidth / 200).floor().clamp(1, 20),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 16 / 7,
            ),
            itemBuilder: (context, index) {
              final person = squad[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade100),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        person.name ?? '-',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        person.position != null
                            ? describeEnum(person.position!)
                            : '-',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: 20,
          );
        }),
      ],
    );
  }
}

class TeamBaseDataWidget extends StatelessWidget {
  final Team team;

  const TeamBaseDataWidget({
    Key? key,
    required this.team,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 30),
        TeamCrest(crestUrl: team.crestUrl!),
        const SizedBox(height: 10),
        Text(
          "${team.name ?? '-'} (${team.shortName ?? ''})".trim(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        TextButton(
          onPressed: () async {
            if (await canLaunch(team.website!)) {
              launch(team.website!);
            }
          },
          child: Padding(
            // To give the button some space between the text and the borders on hover
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              team.website ?? '',
              style: TextStyle(color: Colors.blue, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text('Founded ${team.founded}', textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text(team.address ?? '-', textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text(team.venue ?? '-', textAlign: TextAlign.center),
      ],
    );
  }
}

class TeamCrest extends StatelessWidget {
  const TeamCrest({
    Key? key,
    required this.crestUrl,
  }) : super(key: key);

  final String crestUrl;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(crestUrl);
    if (uri.pathSegments.last.endsWith('.svg')) {
      return SvgPicture.network(crestUrl);
    }
    return Image.network(crestUrl);
  }
}
