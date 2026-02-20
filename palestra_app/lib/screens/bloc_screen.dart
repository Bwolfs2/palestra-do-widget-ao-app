import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/theme.dart';
import '../widgets/code_viewer.dart';
import '../widgets/shared_widgets.dart';

// ─── BLoC ───────────────────────────────────────────────────────────────────

abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}

class ResetEvent extends CounterEvent {}

class CounterState {
  final int count;
  final String lastEvent;
  const CounterState({required this.count, required this.lastEvent});
  CounterState copyWith({int? count, String? lastEvent}) => CounterState(
    count: count ?? this.count,
    lastEvent: lastEvent ?? this.lastEvent,
  );
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(count: 0, lastEvent: 'Nenhum')) {
    on<IncrementEvent>(
      (event, emit) => emit(
        state.copyWith(count: state.count + 1, lastEvent: 'IncrementEvent'),
      ),
    );
    on<DecrementEvent>(
      (event, emit) => emit(
        state.copyWith(count: state.count - 1, lastEvent: 'DecrementEvent'),
      ),
    );
    on<ResetEvent>(
      (event, emit) => emit(state.copyWith(count: 0, lastEvent: 'ResetEvent')),
    );
  }
}

// ─── Screen ─────────────────────────────────────────────────────────────────

class BlocScreen extends StatelessWidget {
  const BlocScreen({super.key});

  static const _eventCode = '''// Events
abstract class CounterEvent {}
class IncrementEvent extends CounterEvent {}
class DecrementEvent extends CounterEvent {}
class ResetEvent    extends CounterEvent {}

// State
class CounterState {
  final int count;
  final String lastEvent;
  const CounterState({
    required this.count,
    required this.lastEvent,
  });
}

// Bloc
class CounterBloc
    extends Bloc<CounterEvent, CounterState> {
  CounterBloc()
      : super(CounterState(count: 0,
            lastEvent: 'Nenhum')) {
    on<IncrementEvent>((event, emit) {
      emit(state.copyWith(
        count: state.count + 1,
        lastEvent: 'IncrementEvent',
      ));
    });
    on<DecrementEvent>((event, emit) {
      emit(state.copyWith(
        count: state.count - 1,
        lastEvent: 'DecrementEvent',
      ));
    });
  }
}

// Usage in widget:
BlocProvider(
  create: (_) => CounterBloc(),
  child: BlocBuilder<CounterBloc,
      CounterState>(
    builder: (context, state) {
      return Text('\${state.count}');
    },
  ),
)

// Dispatch event:
context.read<CounterBloc>()
    .add(IncrementEvent());''';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: Builder(
        builder: (context) {
          final isWide = MediaQuery.of(context).size.width > 1000;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  icon: Icons.account_tree_rounded,
                  color: Color(0xFFFF6B9D),
                  title: 'BLoC',
                  subtitle:
                      'Business Logic Component – eventos e estados explícitos',
                  tag: 'app state',
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B9D).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFF6B9D).withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    'O BLoC separa completamente a lógica da UI. Eventos chegam no Bloc, ele processa '
                    'e emite novos estados. A UI nunca modifica estado diretamente — apenas dispara eventos. '
                    'Isso torna a lógica de negócio 100% testável.',
                    style: GoogleFonts.inter(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.codeBorder),
                  ),
                  child: Column(
                    children: [
                      const _BlocFlowDiagram(),
                      const Divider(height: 1),
                      if (isWide)
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: CodeViewer(code: _eventCode),
                                ),
                              ),
                              const VerticalDivider(width: 1),
                              const Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: _BlocDemo(),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: SizedBox(
                                height: 500,
                                child: CodeViewer(code: _eventCode),
                              ),
                            ),
                            const Divider(height: 1),
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: _BlocDemo(),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BlocFlowDiagram extends StatelessWidget {
  const _BlocFlowDiagram();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FlowNode(
              'UI',
              const Color(0xFF8BE9FD),
              Icons.phone_android_rounded,
            ),
            _flowArrow('add(Event)'),
            _FlowNode('Bloc', const Color(0xFFFF6B9D), Icons.settings_rounded),
            _flowArrow('emit(State)'),
            _FlowNode(
              'State',
              const Color(0xFFFFA94D),
              Icons.data_object_rounded,
            ),
            _flowArrow('rebuild'),
            _FlowNode(
              'UI',
              const Color(0xFF8BE9FD),
              Icons.phone_android_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _flowArrow(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.firaCode(
              color: AppTheme.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          const Icon(
            Icons.arrow_forward_rounded,
            color: AppTheme.textSecondary,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _FlowNode extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _FlowNode(this.label, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.firaCode(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BlocDemo extends StatefulWidget {
  const _BlocDemo();

  @override
  State<_BlocDemo> createState() => _BlocDemoState();
}

class _BlocDemoState extends State<_BlocDemo> {
  final List<String> _eventLog = [];

  void _dispatch(BuildContext ctx, CounterEvent event) {
    ctx.read<CounterBloc>().add(event);
    setState(() => _eventLog.insert(0, '→ ${event.runtimeType}'));
    if (_eventLog.length > 10) _eventLog.removeLast();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  '${state.count}',
                  style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B9D).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFF6B9D).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    'Último evento: ${state.lastEvent}',
                    style: GoogleFonts.firaCode(
                      color: const Color(0xFFFF6B9D),
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleButton(
                      Icons.remove_rounded,
                      AppTheme.secondary,
                      () => _dispatch(context, DecrementEvent()),
                    ),
                    const SizedBox(width: 12),
                    CircleButton(
                      Icons.refresh_rounded,
                      AppTheme.textSecondary,
                      () => _dispatch(context, ResetEvent()),
                    ),
                    const SizedBox(width: 12),
                    CircleButton(
                      Icons.add_rounded,
                      AppTheme.tertiary,
                      () => _dispatch(context, IncrementEvent()),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(
              Icons.terminal_rounded,
              size: 12,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              'Event Stream',
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: AppTheme.codeBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.codeBorder),
          ),
          child: _eventLog.isEmpty
              ? Center(
                  child: Text(
                    'Dispatche um evento para começar',
                    style: GoogleFonts.firaCode(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: _eventLog
                      .asMap()
                      .entries
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            e.value,
                            style: GoogleFonts.firaCode(
                              color: e.key == 0
                                  ? const Color(0xFFFF6B9D)
                                  : AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: e.key == 0
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }
}
