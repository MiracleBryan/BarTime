part of '../../main.dart';

class CocktailCalendarView extends StatefulWidget {
  const CocktailCalendarView({
    required this.memories,
    required this.onAddMemory,
    required this.onAddMemoryForDate,
    required this.onEditMemory,
    required this.onDeleteMemory,
    super.key,
  });

  final List<CocktailMemory> memories;
  final VoidCallback onAddMemory;
  final ValueChanged<DateTime> onAddMemoryForDate;
  final ValueChanged<CocktailMemory> onEditMemory;
  final ValueChanged<CocktailMemory> onDeleteMemory;

  @override
  State<CocktailCalendarView> createState() => _CocktailCalendarViewState();
}

class _CocktailCalendarViewState extends State<CocktailCalendarView> {
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    final firstMemoryDate =
        widget.memories.isEmpty ? DateTime.now() : widget.memories.first.date;
    _visibleMonth = DateTime(firstMemoryDate.year, firstMemoryDate.month);
  }

  @override
  Widget build(BuildContext context) {
    final memoriesByDate = <String, List<CocktailMemory>>{};
    for (final memory in widget.memories) {
      memoriesByDate.putIfAbsent(memory.dateKey, () => []).add(memory);
    }

    final calendarDays = _calendarDaysFor(_visibleMonth);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        Row(
          children: [
            IconButton.filledTonal(
              tooltip: 'Previous month',
              onPressed: () => _changeMonth(-1),
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Text(
                monthTitle(_visibleMonth),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF3E7FA8),
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            IconButton.filled(
              tooltip: 'Add footprint',
              onPressed: widget.onAddMemory,
              icon: const Icon(Icons.add_a_photo),
            ),
            const SizedBox(width: 6),
            IconButton.filledTonal(
              tooltip: 'Next month',
              onPressed: () => _changeMonth(1),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const CalendarWeekdayHeader(),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: calendarDays.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.82,
          ),
          itemBuilder: (context, index) {
            final day = calendarDays[index];
            final memories = memoriesByDate[dateOnlyKey(day)] ?? [];

            return CalendarDayCell(
              day: day,
              visibleMonth: _visibleMonth,
              memories: memories,
              onTap: memories.isEmpty
                  ? () => widget.onAddMemoryForDate(day)
                  : () => _showMemoriesForDate(context, day, memories),
            );
          },
        ),
        if (widget.memories.isEmpty) ...[
          const SizedBox(height: 20),
          Text(
            'No footprints yet',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF3E7FA8),
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap the camera button in the corner to add your first cocktail footprint.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }

  void _changeMonth(int offset) {
    setState(() {
      _visibleMonth =
          DateTime(_visibleMonth.year, _visibleMonth.month + offset);
    });
  }

  void _showMemoriesForDate(
    BuildContext context,
    DateTime date,
    List<CocktailMemory> memories,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ThemedRecipeSheet(
        child: DateMemoriesSheet(
          date: date,
          memories: memories,
          onAddMemory: widget.onAddMemoryForDate,
          onEditMemory: widget.onEditMemory,
          onDeleteMemory: widget.onDeleteMemory,
        ),
      ),
    );
  }

  List<DateTime> _calendarDaysFor(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month);
    final leadingDays = firstDayOfMonth.weekday % 7;
    final firstCalendarDay =
        firstDayOfMonth.subtract(Duration(days: leadingDays));

    return List.generate(
      42,
      (index) => firstCalendarDay.add(Duration(days: index)),
    );
  }
}

class CalendarWeekdayHeader extends StatelessWidget {
  const CalendarWeekdayHeader({super.key});

  final List<String> weekdays = const ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: weekdays
          .map(
            (weekday) => Expanded(
              child: Text(
                weekday,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF3E7FA8),
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    required this.day,
    required this.visibleMonth,
    required this.memories,
    required this.onTap,
    super.key,
  });

  final DateTime day;
  final DateTime visibleMonth;
  final List<CocktailMemory> memories;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isCurrentMonth = day.month == visibleMonth.month;
    final hasMemory = memories.isNotEmpty;

    return Material(
      color: hasMemory ? const Color(0xFFFFFFFF) : const Color(0xCCF8FCFF),
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  hasMemory ? const Color(0xFF8ECDF7) : const Color(0x338ECDF7),
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${day.day}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isCurrentMonth
                            ? const Color(0xFF245B7C)
                            : const Color(0x773E7FA8),
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: hasMemory
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CocktailMemoryImage(
                            memory: memories.first,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                if (memories.length > 1)
                  Text(
                    '+${memories.length - 1}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF3E7FA8),
                          fontWeight: FontWeight.w700,
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

class DateMemoriesSheet extends StatelessWidget {
  const DateMemoriesSheet({
    required this.date,
    required this.memories,
    required this.onAddMemory,
    required this.onEditMemory,
    required this.onDeleteMemory,
    super.key,
  });

  final DateTime date;
  final List<CocktailMemory> memories;
  final ValueChanged<DateTime> onAddMemory;
  final ValueChanged<CocktailMemory> onEditMemory;
  final ValueChanged<CocktailMemory> onDeleteMemory;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FormHeader(title: formatDate(date)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                onAddMemory(date);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add cocktail for this day'),
            ),
          ),
          const SizedBox(height: 16),
          ...memories.map(
            (memory) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: CocktailMemoryCard(
                memory: memory,
                onEdit: () {
                  Navigator.of(context).pop();
                  onEditMemory(memory);
                },
                onDelete: () {
                  Navigator.of(context).pop();
                  onDeleteMemory(memory);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CocktailMemoryCard extends StatelessWidget {
  const CocktailMemoryCard({
    required this.memory,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final CocktailMemory memory;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 220,
            width: double.infinity,
            child: CocktailMemoryImage(memory: memory, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memory.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      if (memory.barName.isNotEmpty) ...[
                        Text(memory.barName),
                        const SizedBox(height: 2),
                      ],
                      if (memory.location.isNotEmpty) ...[
                        Text(memory.location),
                        const SizedBox(height: 2),
                      ],
                      Text(formatDate(memory.date)),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit footprint',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  tooltip: 'Delete footprint',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CocktailMemoryImage extends StatelessWidget {
  const CocktailMemoryImage({
    required this.memory,
    required this.fit,
    super.key,
  });

  final CocktailMemory memory;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes;
    try {
      imageBytes = memory.imageBytes;
    } on FormatException {
      return const _ImagePlaceholder();
    }

    return Image.memory(
      imageBytes,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => const _ImagePlaceholder(),
    );
  }
}
