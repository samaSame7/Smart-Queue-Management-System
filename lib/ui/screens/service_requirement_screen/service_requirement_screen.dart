import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../widgets/build_search_widget.dart';
import '../../widgets/build_service_message.dart';
import '../../widgets/faq_dm.dart';
import '../../../data/service_requirements_api_service.dart';

class ServiceRequirementScreen extends StatefulWidget {
  const ServiceRequirementScreen({super.key});
  static const String routeName = "serviceRequirements";

  @override
  State<ServiceRequirementScreen> createState() =>
      _ServiceRequirementScreenState();
}

class _ServiceRequirementScreenState
    extends State<ServiceRequirementScreen> {
  String? _openId;
  String _search = "";

  final ServiceRequirementsApiService _api =
      ServiceRequirementsApiService();

  late Future<List<FaqDm>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchServiceRequirements();
  }

  void _reload() {
    setState(() {
      _openId = null;
      _future = _api.fetchServiceRequirements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.babyBlue,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.east_rounded,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "متطلبات الخدمة",
                        style: AppStyles.blue26regular,
                      ),
                    ),
                    BuildSearchWidget(
                      onChanged: (value) {
                        setState(() {
                          _search = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: FutureBuilder<List<FaqDm>>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: ElevatedButton(
                            onPressed: _reload,
                            child: const Text("إعادة المحاولة"),
                          ),
                        );
                      }

                      final allItems = snapshot.data ?? [];
                      final items = _search.trim().isEmpty
                          ? allItems
                          : allItems.where((e) {
                              final queryWords = _search
                                  .trim()
                                  .toLowerCase()
                                  .split(RegExp(r'\s+'));
                              final title = e.title.toLowerCase();
                              final content = e.content.toLowerCase();

                              return queryWords.any((word) =>
                                  title.contains(word) ||
                                  content.contains(word));
                            }).toList();

                      if (items.isEmpty) {
                        return const Center(
                          child: Text(
                            "لا توجد نتائج بحث",
                            style: AppStyles.blue16regular,
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final isOpen = _openId == item.id;

                          return BuildServiceWidget(
                            item: item,
                            isOpen: isOpen,
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _openId = expanded ? item.id : null;
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}