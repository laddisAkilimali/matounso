import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class AjouterPermission extends StatefulWidget {
  final List<String>? toutesLesPermissions;
  final List<String> permissionsSelectionnees;
  final ValueChanged<List<String>> onSelectionChange;

  const AjouterPermission({
    super.key,
    required this.toutesLesPermissions,
    required this.permissionsSelectionnees,
    required this.onSelectionChange,
  });

  @override
  State<AjouterPermission> createState() => _AjouterPermissionState();
}

class _AjouterPermissionState extends State<AjouterPermission> {
  late List<String> _courantes;

  @override
  void initState() {
    super.initState();
    _courantes = List<String>.from(widget.permissionsSelectionnees);
  }

  @override
  void didUpdateWidget(covariant AjouterPermission oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(
      oldWidget.permissionsSelectionnees,
      widget.permissionsSelectionnees,
    )) {
      setState(() {
        _courantes = List<String>.from(widget.permissionsSelectionnees);
      });
    }
  }

  void _toggle(String permission, bool coche) {
    setState(() {
      if (coche) {
        if (!_courantes.contains(permission)) {
          _courantes.add(permission);
        }
      } else {
        _courantes.remove(permission);
      }
    });
    widget.onSelectionChange(List<String>.from(_courantes));
  }

  @override
  Widget build(BuildContext context) {
    final permissions = widget.toutesLesPermissions ?? [];
    const colonnes = 3;
    final lignes = (permissions.length + colonnes - 1) ~/ colonnes;

    return LayoutGrid(
      columnSizes: repeat(colonnes, [1.fr]),
      rowSizes: repeat(lignes, [auto]),
      children: [
        for (var index = 0; index < permissions.length; index++)
          CheckboxListTile(
            activeColor: Colors.blue,
            title: Text(permissions[index]),
            value: _courantes.contains(permissions[index]),
            onChanged: (value) => _toggle(permissions[index], value ?? false),
          ).withGridPlacement(
            columnStart: index % colonnes,
            rowStart: index ~/ colonnes,
          ),
      ],
    );
  }
}
