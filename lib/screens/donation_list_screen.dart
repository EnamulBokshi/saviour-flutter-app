import 'package:flutter/material.dart';
import '../services/donation_service.dart';

class DonationListScreen extends StatefulWidget {
  final String? donorId;
  final String? bloodRequestId;
  const DonationListScreen({Key? key, this.donorId, this.bloodRequestId}) : super(key: key);

  @override
  State<DonationListScreen> createState() => _DonationListScreenState();
}

class _DonationListScreenState extends State<DonationListScreen> {
  late Future<List<dynamic>> _donationsFuture;

  @override
  void initState() {
    super.initState();
    _donationsFuture = DonationService().listDonations(
      filters: {
        if (widget.donorId != null) 'donorId': widget.donorId,
        if (widget.bloodRequestId != null) 'bloodRequestId': widget.bloodRequestId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donations')),
      body: FutureBuilder<List<dynamic>>(
        future: _donationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          }
          final donations = snapshot.data ?? [];
          if (donations.isEmpty) {
            return const Center(child: Text('No donations found.'));
          }
          return ListView.separated(
            itemCount: donations.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, i) {
              final d = donations[i];
              return ListTile(
                title: Text('Donation #${d['id'] ?? ''}'),
                subtitle: Text('Status: ${d['status'] ?? ''}\nDate: ${d['donationDate'] ?? ''}'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Show details or allow update/delete
                },
              );
            },
          );
        },
      ),
    );
  }
}
