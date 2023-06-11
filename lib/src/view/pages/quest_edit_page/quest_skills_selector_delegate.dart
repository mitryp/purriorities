import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/skill.dart';
import '../../../typedefs.dart';
import '../../widgets/skill_tile.dart';

class SkillsSearchDelegate extends SearchDelegate<Skill> {
  final List<Skill> _options;
  final Callback<Skill> _skillSelectedCallback;

  SkillsSearchDelegate({
    required List<Skill> options,
    required Callback<Skill> skillSelectedCallback,
  })  : _options = options,
        _skillSelectedCallback = skillSelectedCallback;

  @override
  Widget buildSuggestions(BuildContext context) {
    final normalizedQuery = query.toLowerCase();
    final searchResults = _options
        .where((skill) => skill.name.toLowerCase().contains(normalizedQuery))
        .toList(growable: false);

    return ListView.builder(
      itemCount: _options.length,
      itemBuilder: (context, index) {
        final skill = searchResults[index];

        return SkillTile(
          skill,
          onPressed: () {
            context.pop();
            _skillSelectedCallback(skill);
          },
        );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return const [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);
}
