import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graduation_project/data/models/ticket_item.dart';
import 'package:graduation_project/data/socket_service.dart';
import 'package:graduation_project/data/ticket_api_service.dart';
import 'package:graduation_project/ui/screens/main_screen/main_screen.dart';
import 'package:graduation_project/ui/screens/thanks_screen/thanks_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../widgets/app_button.dart';
import 'build_customer_number.dart';
import 'build_customer_status.dart';
import 'build_waiting_number.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});
  static const String routeName = "ticketScreen";

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final TicketApiService _ticketApi = TicketApiService();
  final SocketService _socketService = SocketService();

  StreamSubscription<Map<String, dynamic>>? _ticketUpdatedSub;
  StreamSubscription<Map<String, dynamic>>? _ticketCalledSub;
  StreamSubscription<Map<String, dynamic>>? _serviceStatsSub;

  TicketItem? _ticket;
  int _remaining = 0;
  String _status = 'pending';

  String _statusLabel(String status) {
    switch (status) {
      case 'in_progress':
        return 'قيد التنفيذ';
      case 'finished':
        return 'تم الانتهاء';
      case 'canceled':
        return 'تم الإلغاء';
      case 'skipped':
        return 'تم التجاوز';
      default:
        return 'في الانتظار';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'in_progress':
        return Colors.orange.shade100;
      case 'finished':
        return Colors.green.shade100;
      case 'canceled':
        return Colors.red.shade100;
      case 'skipped':
        return Colors.grey.shade300;
      default:
        return AppColors.gray;
    }
  }

  Color _statusTextColor(String status) {
    switch (status) {
      case 'in_progress':
        return Colors.orange.shade900;
      case 'finished':
        return Colors.green.shade900;
      case 'canceled':
        return Colors.red.shade900;
      case 'skipped':
        return Colors.grey.shade800;
      default:
        return AppColors.darkBlue;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ticket != null) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! TicketItem) return;

    _ticket = args;
    _status = args.status;

    _socketService.connect();
    _socketService.subscribe(serviceId: args.serviceId, ticketId: args.id);

    _ticketUpdatedSub = _socketService.ticketUpdatedStream.listen((payload) {
      if ((payload['ticketId'] ?? '').toString() != args.id) return;
      if (!mounted) return;
      setState(() {
        _status = (payload['status'] ?? _status).toString();
        final rem = payload['remaining'];
        if (rem is num) _remaining = rem.toInt();
      });
    });

    _ticketCalledSub = _socketService.ticketCalledStream.listen((payload) {
      if ((payload['ticketId'] ?? '').toString() != args.id) return;
      if (!mounted) return;
      setState(() {
        _status = 'in_progress';
      });
    });

    _serviceStatsSub = _socketService.serviceStatsStream.listen((payload) {
      if ((payload['serviceId'] ?? '').toString() != args.serviceId) return;
      final rem = payload['remaining'];
      if (!mounted || rem is! num) return;
      setState(() => _remaining = rem.toInt());
    });

    _loadRemaining();
  }

  Future<void> _loadRemaining() async {
    final ticket = _ticket;
    if (ticket == null) return;

    try {
      final remaining = await _ticketApi.getRemainingByTicketId(ticket.id);
      if (!mounted) return;
      setState(() => _remaining = remaining);
    } catch (_) {}
  }

  Future<void> _cancelTicket() async {
    final ticket = _ticket;
    if (ticket == null) return;

    try {
      await _ticketApi.cancelTicket(ticket.id);
      if (!mounted) return;
      Navigator.pushNamed(context, MainScreen.routeName);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل في إلغاء التذكرة'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    final t = _ticket;
    if (t != null) {
      _socketService.unsubscribe(serviceId: t.serviceId, ticketId: t.id);
    }
    _ticketUpdatedSub?.cancel();
    _ticketCalledSub?.cancel();
    _serviceStatsSub?.cancel();
    _socketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: AppColors.lightBlue,
      borderRadius: BorderRadius.circular(18),
    );

    final ticket = _ticket;
    if (ticket == null) {
      return const Scaffold(
        body: Center(child: Text('لا توجد بيانات تذكرة')),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.babyBlue,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 25),
              const Text(
                'التذكرة الحالية',
                style: AppStyles.blue26regular,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35),
              BuildCustomerNumber(ticketNo: ticket.ticketNo),
              const SizedBox(height: 25),
              BuildWaitingNumber(decoration: decoration, remaining: _remaining),
              const SizedBox(height: 20),
              BuildCustomerStatus(
                decoration: decoration,
                statusLabel: _statusLabel(_status),
                statusColor: _statusColor(_status),
                statusTextColor: _statusTextColor(_status),
              ),
              const Spacer(),
              AppButton(
                onPress: () {
                  Navigator.pushNamed(context, ThanksScreen.routeName);
                },
                text: 'إنهاء',
                bkColor: AppColors.white,
                foreColor: AppColors.darkBlue,
                isDisabled: _status != 'finished',
              ),
              const SizedBox(height: 10),
              AppButton(
                onPress: _cancelTicket,
                text: 'إلغاء التذكرة',
                bkColor: AppColors.blue,
                foreColor: AppColors.white,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
