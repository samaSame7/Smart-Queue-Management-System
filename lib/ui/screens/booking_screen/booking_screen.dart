import 'package:flutter/material.dart';
import '../../../data/models/service_item.dart';
import '../../../data/services_api_service.dart';
import '../../../data/ticket_api_service.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../widgets/app_button.dart';
import '../ticket_screen/ticket_screen.dart';
import 'build_dropdown_button.dart';
import 'build_role_button.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});
  static const String routeName = "bookNow";

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedRole = "طالب";
  String? selectedService;
  bool _isLoadingServices = true;
  bool _isCreatingTicket = false;

  List<ServiceItem> _services = const [];
  final ServicesApiService _servicesApi = ServicesApiService();
  final TicketApiService _ticketApi = TicketApiService();

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _isLoadingServices = true);
    try {
      final data = await _servicesApi.fetchServices();
      if (!mounted) return;
      setState(() {
        _services = data;
        _isLoadingServices = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingServices = false);
    }
  }

  void _changeRole(String newRole) {
    setState(() {
      selectedRole = newRole;
    });
  }

  String _mapRoleToPersonType(String role) {
    switch (role) {
      case "طالب":
        return 'student';
      case "ولي أمر":
        return 'parent';
      default:
        return 'graduate';
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceNames = _services.map((e) => e.name).toList(growable: false);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.babyBlue,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.east_rounded,
                      size: 24,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ),
                const Text(
                  "الحجز",
                  style: AppStyles.blue34regular,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  "اختر صفتك:",
                  style: AppStyles.blue26regular,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    BuildRoleButton(
                      title: "طالب",
                      selectedRole: selectedRole,
                      onRoleChanged: _changeRole,
                    ),
                    const SizedBox(width: 8),
                    BuildRoleButton(
                      title: "ولي أمر",
                      selectedRole: selectedRole,
                      onRoleChanged: _changeRole,
                    ),
                    const SizedBox(width: 8),
                    BuildRoleButton(
                      title: "خريج",
                      selectedRole: selectedRole,
                      onRoleChanged: _changeRole,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "الخدمة المطلوبة:",
                  style: AppStyles.blue26regular,
                ),
                const SizedBox(height: 8),
                if (_isLoadingServices)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  BuildDropdownButton(
                    items: serviceNames,
                    selectedService: selectedService,
                    onChanged: (newValue) {
                      setState(() {
                        selectedService = newValue;
                      });
                    },
                  ),
                const SizedBox(height: 40),
                Expanded(
                  child: Image.asset(
                    AppAssets.bookingImg,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  isLoading: _isCreatingTicket,
                  onPress: () async {
                    if (_isLoadingServices || _isCreatingTicket) return;

                    if (selectedService == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "يرجى اختيار الخدمة المطلوبة أولاً",
                            style: AppStyles.white20regular,
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final selected = _services.where((e) => e.name == selectedService).toList();
                    if (selected.isEmpty) return;

                    setState(() => _isCreatingTicket = true);
                    try {
                      final created = await _ticketApi.createTicket(
                        serviceId: selected.first.id,
                        personType: _mapRoleToPersonType(selectedRole),
                      );

                      if (!context.mounted) return;
                      Navigator.pushNamed(
                        context,
                        TicketScreen.routeName,
                        arguments: created,
                      );
                    } catch (_) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('فشل في إنشاء التذكرة'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      if (mounted) setState(() => _isCreatingTicket = false);
                    }
                  },
                  text: 'تأكيد الحجز',
                  foreColor: AppColors.white,
                  bkColor: AppColors.blue,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
