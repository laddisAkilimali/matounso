import 'package:flutter/material.dart';
import 'package:meditrackui/pages/theme/theme_notifier_page.dart';
import 'package:meditrackui/pages/widgetsPage/datetextfield_page.dart';
import 'package:meditrackui/pages/widgetsPage/dropdownButtonFormField_page.dart';
import 'package:meditrackui/pages/widgetsPage/textformfield_page.dart';
import 'package:meditrackui/services/auth_service.dart';
import 'package:meditrackui/services/inscription_utilisateur_service.dart';
import 'package:provider/provider.dart';

class MyAddPersonnelPage extends StatefulWidget {
  final String userRole;
  final String userName;
  const MyAddPersonnelPage({
    super.key,
    required this.userRole,
    required this.userName,
  });

  @override
  State<MyAddPersonnelPage> createState() => _MyAddPersonnelPageState();
}

class _MyAddPersonnelPageState extends State<MyAddPersonnelPage> {
  final _formKeyIdentite = GlobalKey<FormState>();
  final _formKeyAdresse = GlobalKey<FormState>();
  final _formKeyRole = GlobalKey<FormState>();
  final _formKeyContact = GlobalKey<FormState>();
  final inscriptionService = InscriptionUtilisateurService();

  String? nom;
  String? postNom;
  String? preNom;
  String? sexe;
  DateTime? dateNaissance;
  String? lieuNaissance;
  String? nationalite;

  String? ville;
  String? quartier;
  String? avenue;
  String? numeroMaison;

  String? role;
  List<String> permissions = [];
  List<String>? permissionsSelectionnees = [];

  String? numeroTelephone;
  String? email;
  String? motDePasse;

  bool _loadingPermissions = true;

  @override
  void initState() {
    super.initState();
    _chargerPermissions();
  }

  Future<void> _chargerPermissions() async {
    try {
      final resultat = await AuthService().getAllPermissions();
      if (!mounted) return;
      setState(() {
        permissions = resultat;
        _loadingPermissions = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingPermissions = false);
    }
  }

  bool _valider(GlobalKey<FormState> key) {
    final form = key.currentState;
    if (form == null) return false;
    if (!form.validate()) return false;
    form.save();
    return true;
  }

  void _reinitialiser() {
    FocusScope.of(context).unfocus();
    for (final key in [
      _formKeyIdentite,
      _formKeyAdresse,
      _formKeyRole,
      _formKeyContact,
    ]) {
      key.currentState?.reset();
    }
    setState(() => permissionsSelectionnees = []);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Les formulaires ont été réinitialisés.')),
    );
  }

  void _soumettre() async {
    FocusScope.of(context).unfocus();
    final sections = [
      _formKeyIdentite,
      _formKeyAdresse,
      _formKeyRole,
      _formKeyContact,
    ];
    final valide = sections.every(_valider);
    if (!valide) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Merci de compléter les sections en surbrillance.',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    final inscription = await inscriptionService.inscriptionUtilisateur(
      nom,
      postNom,
      preNom,
      sexe,
      dateNaissance,
      lieuNaissance,
      nationalite,
      ville,
      quartier,
      avenue,
      numeroMaison,
      role,
      permissionsSelectionnees,
      numeroTelephone,
      email,
      motDePasse,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(inscription.toString())));

    if (inscription == 'succes') {
      _reinitialiser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        titleSpacing: 24,
        leading: const Icon(Icons.person_add_alt_1_outlined),
        title: Text(
          widget.userRole == 'SUPER_ADMIN'
              ? 'Ajouter un administrateur'
              : 'Ajouter un personnel',
        ),
        actions: [
          IconButton(
            tooltip: themeNotifier.themeMode == ThemeMode.dark
                ? 'Basculer en mode clair'
                : 'Basculer en mode sombre',
            icon: Icon(
              themeNotifier.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: themeNotifier.toggleBetweenLightAndDark,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (_loadingPermissions) {
              return const Center(
                child: SizedBox(
                  height: 48,
                  width: 48,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final useTwoColumns = constraints.maxWidth >= 900;
            final paddingHorizontal = constraints.maxWidth >= 900 ? 48.0 : 24.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal,
                vertical: 28,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(theme, colorScheme),
                      const SizedBox(height: 24),
                      if (useTwoColumns)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  _buildIdentite(theme, colorScheme),
                                  const SizedBox(height: 24),
                                  _buildAdresse(theme, colorScheme),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                children: [
                                  _buildRole(theme, colorScheme),
                                  const SizedBox(height: 24),
                                  _buildContact(theme, colorScheme),
                                ],
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildIdentite(theme, colorScheme),
                            const SizedBox(height: 24),
                            _buildAdresse(theme, colorScheme),
                            const SizedBox(height: 24),
                            _buildRole(theme, colorScheme),
                            const SizedBox(height: 24),
                            _buildContact(theme, colorScheme),
                          ],
                        ),
                      const SizedBox(height: 32),
                      _buildActions(theme),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: isDark ? 0.55 : 0.8),
            colorScheme.secondary.withValues(alpha: isDark ? 0.35 : 0.65),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.2),
                child: Icon(Icons.badge_outlined, color: colorScheme.onPrimary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fiche collaborateur',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Complétez les informations puis attribuez les droits adaptés avant validation.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildBadge(
                theme,
                colorScheme,
                Icons.account_tree_outlined,
                'Processus guidé',
              ),
              _buildBadge(
                theme,
                colorScheme,
                Icons.security_outlined,
                'Permissions dynamiques',
              ),
              _buildBadge(
                theme,
                colorScheme,
                Icons.schedule_outlined,
                'Validation rapide',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(
    ThemeData theme,
    ColorScheme colorScheme,
    IconData icon,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: colorScheme.onPrimary),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(
                            alpha: 0.75,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 32),
          child,
        ],
      ),
    );
  }

  Widget _buildIdentite(ThemeData theme, ColorScheme colorScheme) {
    return _buildSectionCard(
      theme: theme,
      colorScheme: colorScheme,
      icon: Icons.badge_outlined,
      title: 'Identité',
      subtitle: 'Informations personnelles du collaborateur.',
      child: Form(
        key: _formKeyIdentite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              label: 'Nom',
              validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Champ requis' : null,
              onSaved: (val) => nom = val?.trim(),
              hintText: 'Entrez le nom',
            ),
            MyTextField(
              label: 'Post-nom',
              validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Champ requis' : null,
              onSaved: (val) => postNom = val?.trim(),
              hintText: 'Entrez le post-nom',
            ),
            MyTextField(
              label: 'Prénom',
              validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Champ requis' : null,
              onSaved: (val) => preNom = val?.trim(),
              hintText: 'Entrez le prénom',
            ),
            MyDropdownButtonFormField(
              elementListe: const ['FEMININ', 'MASCULIN', 'AUTRE'],
              hint: 'Sélectionnez le sexe',
              label: 'Sexe',
              validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Champ requis' : null,
              onSaved: (val) => sexe = val?.trim(),
            ),
            MyDateField(
              label: 'Date de naissance',
              onSaved: (date) => dateNaissance = date,
              hintText: 'Choisissez la date de naissance',
            ),
            MyTextField(
              label: 'Lieu de naissance',
              validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Champ requis' : null,
              onSaved: (val) => lieuNaissance = val?.trim(),
              hintText: 'Entrez le lieu de naissance',
            ),
            MyTextField(
              label: 'Nationalité',
              validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Champ requis' : null,
              onSaved: (val) => nationalite = val?.trim(),
              hintText: 'Entrez la nationalité',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdresse(ThemeData theme, ColorScheme colorScheme) {
    return _buildSectionCard(
      theme: theme,
      colorScheme: colorScheme,
      icon: Icons.location_city_outlined,
      title: 'Adresse',
      subtitle: 'Coordonnées du lieu de résidence.',
      child: Form(
        key: _formKeyAdresse,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              label: 'Ville',
              validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Champ requis' : null,
              onSaved: (val) => ville = val?.trim(),
              hintText: 'Entrez la ville',
            ),
            MyTextField(
              label: 'Quartier',
              validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Champ requis' : null,
              onSaved: (val) => quartier = val?.trim(),
              hintText: 'Entrez le quartier',
            ),
            MyTextField(
              label: 'Avenue',
              validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Champ requis' : null,
              onSaved: (val) => avenue = val?.trim(),
              hintText: 'Entrez l’avenue',
            ),
            MyTextField(
              label: 'Numéro de maison',
              validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Champ requis' : null,
              onSaved: (val) => numeroMaison = val?.trim(),
              keyboardType: TextInputType.number,
              hintText: 'Entrez le numéro de maison',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRole(ThemeData theme, ColorScheme colorScheme) {
    return _buildSectionCard(
      theme: theme,
      colorScheme: colorScheme,
      icon: Icons.security,
      title: 'Rôle et permissions',
      subtitle: 'Définissez les droits associés à ce profil.',
      child: Form(
        key: _formKeyRole,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              label: 'Rôle',
              validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Champ requis' : null,
              onSaved: (val) => role = val?.trim(),
              hintText: 'Entrez le rôle (ex : médecin, infirmier …)',
            ),
            const SizedBox(height: 16),
            Text(
              'Sélectionnez les permissions adaptées aux missions confiées.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              children: [
                if (permissions.isNotEmpty)
                  ...permissions.map((permission) {
                    return SizedBox(
                      width: 200,
                      child: CheckboxListTile(
                        title: Text(permission),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: permissionsSelectionnees!.contains(permission),
                        onChanged: (isSelected) {
                          setState(() {
                            if (isSelected == true) {
                              permissionsSelectionnees!.add(permission);
                            } else {
                              permissionsSelectionnees!.remove(permission);
                            }
                          });
                        },
                      ),
                    );
                  }),
              ],
            ),
            if (permissions.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Aucune permission disponible pour le moment.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContact(ThemeData theme, ColorScheme colorScheme) {
    return _buildSectionCard(
      theme: theme,
      colorScheme: colorScheme,
      icon: Icons.contact_phone_outlined,
      title: 'Coordonnées et accès',
      subtitle: 'Informations de contact et sécurisation du compte.',
      child: Form(
        key: _formKeyContact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              label: 'Numéro de téléphone',
              validator: (val) {
                final value = val?.trim() ?? '';
                if (value.isEmpty) return 'Champ requis';
                final regExp = RegExp(r'^\+?\d{8,15}$');
                if (!regExp.hasMatch(value)) {
                  return 'Le numéro doit contenir uniquement des chiffres';
                }
                return null;
              },
              onSaved: (val) => numeroTelephone = val?.trim(),
              keyboardType: TextInputType.phone,
              hintText: 'Entrez le numéro de téléphone',
            ),
            MyTextField(
              label: 'Adresse e-mail',
              validator: (val) {
                final value = val?.trim() ?? '';
                if (value.isEmpty) return 'Veuillez entrer votre email';
                final emailRegex = RegExp(
                  r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
                );
                if (!emailRegex.hasMatch(value)) {
                  return 'Veuillez entrer un email valide';
                }
                return null;
              },
              onSaved: (val) => email = val?.trim(),
              keyboardType: TextInputType.emailAddress,
              hintText: 'Entrez l’adresse e-mail',
            ),
            MyTextField(
              label: 'Mot de passe',
              validator: (val) {
                final value = val?.trim() ?? '';
                if (value.isEmpty) return 'Champ requis';
                if (value.length < 8) {
                  return 'Le mot de passe doit contenir au moins 8 caractères';
                }
                final strongPwd = RegExp(
                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]+$',
                );
                if (!strongPwd.hasMatch(value)) {
                  return 'Inclure majuscules, minuscules et chiffres';
                }
                return null;
              },
              onSaved: (val) => motDePasse = val,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Entrez le mot de passe',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          OutlinedButton.icon(
            onPressed: _reinitialiser,
            icon: const Icon(Icons.refresh),
            label: const Text('Réinitialiser'),
          ),
          FilledButton.icon(
            onPressed: _soumettre,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
