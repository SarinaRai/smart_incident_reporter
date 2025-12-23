import 'package:flutter/material.dart';
import 'package:smart_incident_reporter/core/utils/date_utlis.dart';

class IncidentCard extends StatelessWidget {
  final String title;
  final String type;
  final String priority;
  final DateTime createdAt;
  final String? imageUrl;
  final VoidCallback onTap;

  const IncidentCard({
    super.key,
    required this.title,
    required this.type,
    required this.priority,
    required this.createdAt,
    this.imageUrl,
    required this.onTap,
  });

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _priorityColor(priority),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      priority,
                      style: TextStyle(
                        color: _priorityColor(priority),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Text(type, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    DateUtilsHelper.formatDate(createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
