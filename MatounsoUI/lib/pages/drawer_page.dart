import 'package:flutter/material.dart';
import 'package:meditrackui/pages/add_personnel_page.dart';

class AppDrawer extends StatefulWidget {
  final String userName;
  final List<String> userPermissions;
  final String userRole;
  final void Function(Widget page)? pageCharge;

  const AppDrawer({
    super.key,
    required this.userName,
    required this.userRole,
    required this.userPermissions,
    this.pageCharge,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  bool isExpanded = true;
  late final AnimationController _controller;
  late final Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _widthAnimation = Tween<double>(begin: 70, end: 250).animate(_controller);
    if (isExpanded) _controller.forward();
  }

  void toggleDrawer() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _openPage(Widget page) {
    final callback = widget.pageCharge;
    if (callback != null) {
      callback(page);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    }
  }

  String _formatRole(String role) {
    const prefix = 'ROLE_';
    if (role.startsWith(prefix)) {
      return role.substring(prefix.length);
    }
    return role;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final permissionMap = <String, Map<String, dynamic>>{
      'AJOUTER ADMIN': {
        'title': 'Ajouter un administrateur',
        'icon': Icons.person_add,
        'onTap': () => _openPage(
          MyAddPersonnelPage(
            userRole: widget.userRole,
            userName: widget.userName,
          ),
        ),
      },
      'AJOUTER PERSONNEL': {
        'title': 'AJOUTER DU PERSONNEL',
        'icon': Icons.person_2,
        'onTap': () {},
      },
    };

    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) {
        return Material(
          elevation: 8,
          child: Container(
            width: _widthAnimation.value,
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: toggleDrawer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 25,

                          child: Icon(Icons.local_hospital, size: 30),
                        ),
                        if (isExpanded) ...[
                          const SizedBox(height: 10),
                          Text(
                            widget.userName.isEmpty
                                ? 'Chargement...'
                                : widget.userName,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 2,
                          ),
                          Text(
                            widget.userRole.isEmpty
                                ? 'Chargement...'
                                : _formatRole(widget.userRole),
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 2,
                          ),
                        ],
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            isExpanded
                                ? Icons.arrow_back_ios
                                : Icons.arrow_forward_ios,

                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Colors.white30, height: 1),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: widget.userPermissions.map((permission) {
                      final config = permissionMap[permission];
                      if (config == null) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(config['icon'] as IconData),
                              onPressed: config['onTap'] as void Function()?,
                              tooltip: config['title'] as String?,
                            ),
                            if (isExpanded)
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 10,
                                    ),
                                  ),
                                  onPressed:
                                      config['onTap'] as void Function()?,
                                  child: Text(
                                    config['title'] as String,

                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 2,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Divider(color: Colors.white30, height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () {},
                          ),
                          if (isExpanded)
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Paramètre',

                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.red),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          if (isExpanded)
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Déconnexion',

                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
