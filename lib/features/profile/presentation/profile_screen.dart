import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {}, // Espaço para futura tela de configurações
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // Avatar do Usuário com um detalhe roxo
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: primaryColor.withOpacity(0.2),
                  child: Icon(Icons.person, size: 60, color: primaryColor), // Pode trocar por uma Image.asset depois!
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 20, color: Colors.white),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Text(
              'Matheus',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Focado no Bulking 🚀',
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            ),
            const SizedBox(height: 32),

            // Lista de Opções
            _buildProfileOption(context, Icons.track_changes, 'Minhas Metas', 'Ajustar calorias e peso alvo'),
            const SizedBox(height: 12),
            _buildProfileOption(context, Icons.notifications_active_outlined, 'Lembretes', 'Beber água e refeições'),
            const SizedBox(height: 12),
            _buildProfileOption(context, Icons.history, 'Histórico', 'Ver todos os registros de peso'),
            const SizedBox(height: 12),
            _buildProfileOption(context, Icons.dark_mode_outlined, 'Aparência', 'Tema escuro ativado'),

            const SizedBox(height: 32),
            
            // Botão de Deslogar
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text(
                  'Sair da Conta',
                  style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget reaproveitável para os botões da lista
  Widget _buildProfileOption(BuildContext context, IconData icon, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // Lógica de clique para abrir novas telas no futuro
        },
      ),
    );
  }
}
