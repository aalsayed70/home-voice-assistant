// import 'dart:math' as math;
// import 'dart:ui';

// import 'package:dar/arc_widget.dart';
// import 'package:dar/models/moments.dart';
// import 'package:dar/screens/dashboard.dart';
// import 'package:dar/state.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ConfigureMomentsScreen extends StatelessWidget {
//   const ConfigureMomentsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final smartHome = context.watch<SmartHomeState>();

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/dary1.jpeg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             color: Colors.black.withValues(alpha: 0.3),
//             child: SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 40),
//                     const Text(
//                       'Configure Your\nMoments',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                         height: 1.3,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Expanded(
//                       child: MomentsArc(
//                         startAngle: math.pi / 2,
//                         endAngle: math.pi * 1.5,
//                         centerAlignment: const Alignment(0.68, 0.0),
//                         radiusFactor: 0.60,
//                         sizes: const [110, 110, 110, 110, 110],
//                         items: [
//                           _MomentButton(
//                             moment: smartHome.moments[0],
//                             size: 100,
//                           ),
//                           _MomentButton(
//                             moment: smartHome.moments[1],
//                             size: 100,
//                           ),
//                           _MomentButton(
//                             moment: smartHome.moments[2],
//                             size: 100,
//                           ),
//                           _MomentButton(
//                             moment: smartHome.moments[3],
//                             size: 100,
//                           ),
//                           _MomentButton(
//                             moment: smartHome.moments[4],
//                             size: 100,
//                           ),
//                         ],
//                         centerOverlay: const _AddButton(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _MomentButton extends StatefulWidget {
//   final Moment moment;
//   final double size;

//   const _MomentButton({required this.moment, required this.size});

//   @override
//   State<_MomentButton> createState() => _MomentButtonState();
// }

// class _MomentButtonState extends State<_MomentButton> {
//   bool _isPressed = false;

//   static const _hoverColor = Color(0xFFB8E6B8);

//   @override
//   Widget build(BuildContext context) {
//     final bg = _isPressed ? _hoverColor : widget.moment.color;
//     final textColor = bg == _hoverColor ? Colors.black87 : Colors.white;

//     return GestureDetector(
//       onTapDown: (_) => setState(() => _isPressed = true),
//       onTapUp: (_) => setState(() => _isPressed = false),
//       onTapCancel: () => setState(() => _isPressed = false),
//       onTap: () {
//         context.read<SmartHomeState>().applyMoment(widget.moment);
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const DashboardScreen()),
//         );
//       },
//       child: AnimatedScale(
//         scale: _isPressed ? 1.06 : 1.0,
//         duration: const Duration(milliseconds: 120),
//         curve: Curves.easeOut,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 140),
//           curve: Curves.easeOut,
//           width: widget.size,
//           height: widget.size,
//           decoration: BoxDecoration(
//             color: bg,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.3),
//                 blurRadius: _isPressed ? 14 : 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//             border: _isPressed
//                 ? Border.all(
//                     color: Colors.black.withValues(alpha: 0.12),
//                     width: 1,
//                   )
//                 : null,
//           ),
//           child: Center(
//             child: Text(
//               widget.moment.name,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: textColor,
//                 height: 1.1,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _AddButton extends StatefulWidget {
//   const _AddButton();

//   @override
//   State<_AddButton> createState() => _AddButtonState();
// }

// class _AddButtonState extends State<_AddButton> {
//   bool _isPressed = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) => setState(() => _isPressed = true),
//       onTapUp: (_) => setState(() => _isPressed = false),
//       onTapCancel: () => setState(() => _isPressed = false),
//       onTap: () {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Add new moment coming soon!'),
//             backgroundColor: Color(0xFFB8E6B8),
//           ),
//         );
//       },
//       child: AnimatedScale(
//         scale: _isPressed ? 1.06 : 1.0,
//         duration: const Duration(milliseconds: 120),
//         curve: Curves.easeOut,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 140),
//           curve: Curves.easeOut,
//           width: 60,
//           height: 60,
//           decoration: BoxDecoration(
//             color: const Color(0xFFB8E6B8),
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.3),
//                 blurRadius: _isPressed ? 14 : 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: const Icon(Icons.add, color: Colors.black87, size: 28),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:math' as math;
// import 'dart:ui';

// import 'package:dar/arc_widget.dart';
// import 'package:dar/models/moments.dart';
// import 'package:dar/screens/dashboard.dart';
// import 'package:dar/state.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ConfigureMomentsScreen extends StatefulWidget {
//   const ConfigureMomentsScreen({super.key});

//   @override
//   State<ConfigureMomentsScreen> createState() => _ConfigureMomentsScreenState();
// }

// class _ConfigureMomentsScreenState extends State<ConfigureMomentsScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _titleController;
//   late AnimationController _arcController;
//   late AnimationController _momentsController;
//   late AnimationController _centerController;

//   late Animation<double> _titleFadeAnimation;
//   late Animation<Offset> _titleSlideAnimation;
//   late Animation<double> _arcScaleAnimation;
//   late Animation<double> _arcRotationAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Title animations
//     _titleController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _titleFadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _titleController, curve: Curves.easeOut));

//     _titleSlideAnimation =
//         Tween<Offset>(begin: const Offset(-0.5, 0), end: Offset.zero).animate(
//           CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
//         );

//     // Arc entrance animations
//     _arcController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     _arcScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _arcController, curve: Curves.elasticOut),
//     );

//     _arcRotationAnimation = Tween<double>(begin: math.pi * 2, end: 0.0).animate(
//       CurvedAnimation(parent: _arcController, curve: Curves.easeOutCubic),
//     );

//     // Moments pop-in controller
//     _momentsController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );

//     // Center button controller
//     _centerController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     // Start animation sequence
//     _startAnimationSequence();
//   }

//   void _startAnimationSequence() async {
//     // Start title animation
//     _titleController.forward();

//     // Wait and start arc animation
//     await Future.delayed(const Duration(milliseconds: 300));
//     _arcController.forward();

//     // Wait and start moments animation
//     await Future.delayed(const Duration(milliseconds: 600));
//     _momentsController.forward();

//     // Wait and start center button animation
//     await Future.delayed(const Duration(milliseconds: 1000));
//     _centerController.forward();
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _arcController.dispose();
//     _momentsController.dispose();
//     _centerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final smartHome = context.watch<SmartHomeState>();

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/dary1.jpeg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             color: Colors.black.withValues(alpha: 0.3),
//             child: SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 40),
//                     // Animated title
//                     AnimatedBuilder(
//                       animation: Listenable.merge([
//                         _titleFadeAnimation,
//                         _titleSlideAnimation,
//                       ]),
//                       builder: (context, child) {
//                         return SlideTransition(
//                           position: _titleSlideAnimation,
//                           child: FadeTransition(
//                             opacity: _titleFadeAnimation,
//                             child: const Text(
//                               'Configure Your\nMoments',
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white,
//                                 height: 1.3,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 8),
//                     Expanded(
//                       child: AnimatedBuilder(
//                         animation: Listenable.merge([
//                           _arcScaleAnimation,
//                           _arcRotationAnimation,
//                         ]),
//                         builder: (context, child) {
//                           return Transform.scale(
//                             scale: _arcScaleAnimation.value,
//                             child: Transform.rotate(
//                               angle: _arcRotationAnimation.value,
//                               child: MomentsArc(
//                                 startAngle: math.pi / 2,
//                                 endAngle: math.pi * 1.5,
//                                 centerAlignment: const Alignment(0.68, 0.0),
//                                 radiusFactor: 0.60,
//                                 sizes: const [110, 110, 110, 110, 110],
//                                 items: [
//                                   _MomentButton(
//                                     moment: smartHome.moments[0],
//                                     size: 100,
//                                     animationController: _momentsController,
//                                     delay: 0.0,
//                                   ),
//                                   _MomentButton(
//                                     moment: smartHome.moments[1],
//                                     size: 100,
//                                     animationController: _momentsController,
//                                     delay: 0.15,
//                                   ),
//                                   _MomentButton(
//                                     moment: smartHome.moments[2],
//                                     size: 100,
//                                     animationController: _momentsController,
//                                     delay: 0.3,
//                                   ),
//                                   _MomentButton(
//                                     moment: smartHome.moments[3],
//                                     size: 100,
//                                     animationController: _momentsController,
//                                     delay: 0.45,
//                                   ),
//                                   _MomentButton(
//                                     moment: smartHome.moments[4],
//                                     size: 100,
//                                     animationController: _momentsController,
//                                     delay: 0.6,
//                                   ),
//                                 ],
//                                 centerOverlay: _AnimatedAddButton(
//                                   animationController: _centerController,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _MomentButton extends StatefulWidget {
//   final Moment moment;
//   final double size;
//   final AnimationController animationController;
//   final double delay;

//   const _MomentButton({
//     required this.moment,
//     required this.size,
//     required this.animationController,
//     required this.delay,
//   });

//   @override
//   State<_MomentButton> createState() => _MomentButtonState();
// }

// class _MomentButtonState extends State<_MomentButton>
//     with SingleTickerProviderStateMixin {
//   bool _isPressed = false;
//   late AnimationController _shimmerController;
//   late Animation<double> _popAnimation;
//   late Animation<double> _rotationAnimation;
//   late Animation<double> _glowAnimation;

//   static const _hoverColor = Color(0xFFB8E6B8);

//   @override
//   void initState() {
//     super.initState();

//     // Shimmer animation
//     _shimmerController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );

//     // Pop-in animation with delay
//     _popAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: widget.animationController,
//         curve: Interval(
//           widget.delay,
//           (widget.delay + 0.4).clamp(0.0, 1.0),
//           curve: Curves.elasticOut,
//         ),
//       ),
//     );

//     // Rotation animation
//     _rotationAnimation = Tween<double>(begin: math.pi * 3, end: 0.0).animate(
//       CurvedAnimation(
//         parent: widget.animationController,
//         curve: Interval(
//           widget.delay,
//           (widget.delay + 0.6).clamp(0.0, 1.0),
//           curve: Curves.easeOutCubic,
//         ),
//       ),
//     );

//     // Glow animation
//     _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: widget.animationController,
//         curve: Interval(
//           widget.delay + 0.2,
//           (widget.delay + 0.8).clamp(0.0, 1.0),
//           curve: Curves.easeOut,
//         ),
//       ),
//     );

//     // Start shimmer after pop-in
//     widget.animationController.addStatusListener(_handleAnimationStatus);
//   }

//   void _handleAnimationStatus(AnimationStatus status) {
//     if (status == AnimationStatus.completed) {
//       Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
//         if (mounted) {
//           _shimmerController.repeat();
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     widget.animationController.removeStatusListener(_handleAnimationStatus);
//     _shimmerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bg = _isPressed ? _hoverColor : widget.moment.color;
//     final textColor = bg == _hoverColor ? Colors.black87 : Colors.white;

//     return AnimatedBuilder(
//       animation: Listenable.merge([
//         _popAnimation,
//         _rotationAnimation,
//         _glowAnimation,
//         _shimmerController,
//       ]),
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _popAnimation.value,
//           child: Transform.rotate(
//             angle: _rotationAnimation.value,
//             child: Opacity(
//               opacity: _popAnimation.value.clamp(0.0, 1.0),
//               child: GestureDetector(
//                 onTapDown: (_) => setState(() => _isPressed = true),
//                 onTapUp: (_) => setState(() => _isPressed = false),
//                 onTapCancel: () => setState(() => _isPressed = false),
//                 onTap: () {
//                   context.read<SmartHomeState>().applyMoment(widget.moment);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const DashboardScreen()),
//                   );
//                 },
//                 child: AnimatedScale(
//                   scale: _isPressed ? 1.1 : 1.0,
//                   duration: const Duration(milliseconds: 120),
//                   curve: Curves.easeOut,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 140),
//                     curve: Curves.easeOut,
//                     width: widget.size,
//                     height: widget.size,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [bg, bg.withValues(alpha: 0.8)],
//                       ),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.4),
//                           blurRadius: _isPressed ? 16 : 12,
//                           offset: const Offset(0, 6),
//                         ),
//                         // Glow effect
//                         BoxShadow(
//                           color: bg.withValues(
//                             alpha: (0.4 * _glowAnimation.value).clamp(0.0, 1.0),
//                           ),
//                           blurRadius: 20 * _glowAnimation.value,
//                           spreadRadius: 3 * _glowAnimation.value,
//                         ),
//                         // Shimmer highlight
//                         BoxShadow(
//                           color: Colors.white.withValues(
//                             alpha: (0.1 + 0.2 * _shimmerController.value).clamp(
//                               0.0,
//                               1.0,
//                             ),
//                           ),
//                           blurRadius: 8,
//                           offset: Offset(
//                             -4 * _shimmerController.value,
//                             -4 * _shimmerController.value,
//                           ),
//                         ),
//                       ],
//                       border: Border.all(
//                         color: Colors.white.withValues(
//                           alpha:
//                               (0.2 +
//                                       0.3 * _glowAnimation.value +
//                                       0.1 * _shimmerController.value)
//                                   .clamp(0.0, 1.0),
//                         ),
//                         width: _isPressed ? 2 : 1.5,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         widget.moment.name,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: textColor,
//                           height: 1.1,
//                           shadows: [
//                             Shadow(
//                               color: Colors.black.withValues(alpha: 0.3),
//                               offset: const Offset(1, 1),
//                               blurRadius: 2,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _AnimatedAddButton extends StatefulWidget {
//   final AnimationController animationController;

//   const _AnimatedAddButton({required this.animationController});

//   @override
//   State<_AnimatedAddButton> createState() => _AnimatedAddButtonState();
// }

// class _AnimatedAddButtonState extends State<_AnimatedAddButton>
//     with SingleTickerProviderStateMixin {
//   bool _isPressed = false;
//   late AnimationController _pulseController;
//   late Animation<double> _popAnimation;
//   late Animation<double> _rotationAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _pulseController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );

//     _popAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: widget.animationController,
//         curve: Curves.elasticOut,
//       ),
//     );

//     _rotationAnimation = Tween<double>(begin: math.pi * 4, end: 0.0).animate(
//       CurvedAnimation(
//         parent: widget.animationController,
//         curve: Curves.easeOutCubic,
//       ),
//     );

//     // Start pulsing after pop-in
//     widget.animationController.addStatusListener(_handleCenterAnimationStatus);
//   }

//   void _handleCenterAnimationStatus(AnimationStatus status) {
//     if (status == AnimationStatus.completed && mounted) {
//       _pulseController.repeat();
//     }
//   }

//   @override
//   void dispose() {
//     widget.animationController.removeStatusListener(
//       _handleCenterAnimationStatus,
//     );
//     _pulseController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([
//         _popAnimation,
//         _rotationAnimation,
//         _pulseController,
//       ]),
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _popAnimation.value,
//           child: Transform.rotate(
//             angle: _rotationAnimation.value,
//             child: Opacity(
//               opacity: _popAnimation.value,
//               child: GestureDetector(
//                 onTapDown: (_) => setState(() => _isPressed = true),
//                 onTapUp: (_) => setState(() => _isPressed = false),
//                 onTapCancel: () => setState(() => _isPressed = false),
//                 onTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Add new moment coming soon!'),
//                       backgroundColor: Color(0xFFB8E6B8),
//                       behavior: SnackBarBehavior.floating,
//                     ),
//                   );
//                 },
//                 child: AnimatedScale(
//                   scale: _isPressed ? 1.15 : 1.0,
//                   duration: const Duration(milliseconds: 120),
//                   curve: Curves.easeOut,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 140),
//                     curve: Curves.easeOut,
//                     width: 70,
//                     height: 70,
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [Color(0xFFB8E6B8), Color(0xFF90C695)],
//                       ),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.4),
//                           blurRadius: _isPressed ? 18 : 14,
//                           offset: const Offset(0, 6),
//                         ),
//                         // Pulsing glow
//                         BoxShadow(
//                           color: const Color(0xFFB8E6B8).withOpacity(
//                             (0.4 + 0.3 * _pulseController.value).clamp(
//                               0.0,
//                               1.0,
//                             ),
//                           ),
//                           blurRadius: 20 + (10 * _pulseController.value),
//                           spreadRadius: 2 + (4 * _pulseController.value),
//                         ),
//                       ],
//                       border: Border.all(
//                         color: Colors.white.withValues(
//                           alpha: (0.3 + 0.2 * _pulseController.value).clamp(
//                             0.0,
//                             1.0,
//                           ),
//                         ),
//                         width: 2,
//                       ),
//                     ),
//                     child: const Icon(
//                       Icons.add_rounded,
//                       color: Colors.black87,
//                       size: 32,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:math' as math;
import 'dart:ui';

import 'package:dar/arc_widget.dart';
import 'package:dar/models/moments.dart';
import 'package:dar/screens/dashboard.dart';
import 'package:dar/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigureMomentsScreen extends StatefulWidget {
  const ConfigureMomentsScreen({super.key});

  @override
  State<ConfigureMomentsScreen> createState() => _ConfigureMomentsScreenState();
}

class _ConfigureMomentsScreenState extends State<ConfigureMomentsScreen>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _arcController;
  late AnimationController _momentsController;
  late AnimationController _centerController;

  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<double> _arcScaleAnimation;
  late Animation<double> _arcRotationAnimation;

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _titleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _titleController, curve: Curves.easeOut));

    _titleSlideAnimation =
        Tween<Offset>(begin: const Offset(-0.5, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
        );

    _arcController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _arcScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _arcController, curve: Curves.elasticOut),
    );

    _arcRotationAnimation = Tween<double>(begin: math.pi * 2, end: 0.0).animate(
      CurvedAnimation(parent: _arcController, curve: Curves.easeOutCubic),
    );

    _momentsController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _centerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    _titleController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _arcController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _momentsController.forward();
    await Future.delayed(const Duration(milliseconds: 1000));
    _centerController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _arcController.dispose();
    _momentsController.dispose();
    _centerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final smartHome = context.watch<SmartHomeState>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dary1.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _titleFadeAnimation,
                        _titleSlideAnimation,
                      ]),
                      builder: (context, child) {
                        return SlideTransition(
                          position: _titleSlideAnimation,
                          child: FadeTransition(
                            opacity: _titleFadeAnimation,
                            child: const Text(
                              'Configure Your\nMoments',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: Listenable.merge([
                          _arcScaleAnimation,
                          _arcRotationAnimation,
                        ]),
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _arcScaleAnimation.value,
                            child: Transform.rotate(
                              angle: _arcRotationAnimation.value,
                              child: MomentsArc(
                                startAngle: math.pi / 2,
                                endAngle: math.pi * 1.5,
                                centerAlignment: const Alignment(0.68, 0.0),
                                radiusFactor: 0.60,
                                sizes: const [110, 110, 110, 110, 110],
                                items: [
                                  _MomentButton(
                                    moment: smartHome.moments[0],
                                    size: 100,
                                    animationController: _momentsController,
                                    delay: 0.0,
                                  ),
                                  _MomentButton(
                                    moment: smartHome.moments[1],
                                    size: 100,
                                    animationController: _momentsController,
                                    delay: 0.15,
                                  ),
                                  _MomentButton(
                                    moment: smartHome.moments[2],
                                    size: 100,
                                    animationController: _momentsController,
                                    delay: 0.3,
                                  ),
                                  _MomentButton(
                                    moment: smartHome.moments[3],
                                    size: 100,
                                    animationController: _momentsController,
                                    delay: 0.45,
                                  ),
                                  _MomentButton(
                                    moment: smartHome.moments[4],
                                    size: 100,
                                    animationController: _momentsController,
                                    delay: 0.6,
                                  ),
                                ],
                                centerOverlay: _AnimatedAddButton(
                                  animationController: _centerController,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MomentButton extends StatefulWidget {
  final Moment moment;
  final double size;
  final AnimationController animationController;
  final double delay;

  const _MomentButton({
    required this.moment,
    required this.size,
    required this.animationController,
    required this.delay,
  });

  @override
  State<_MomentButton> createState() => _MomentButtonState();
}

class _MomentButtonState extends State<_MomentButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _shimmerController;
  late Animation<double> _popAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;

  static const _hoverColor = Color(0xFFB8E6B8);

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _popAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          widget.delay,
          (widget.delay + 0.4).clamp(0.0, 1.0),
          curve: Curves.elasticOut,
        ),
      ),
    );

    _rotationAnimation = Tween<double>(begin: math.pi * 3, end: 0.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          widget.delay,
          (widget.delay + 0.6).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          widget.delay + 0.2,
          (widget.delay + 0.8).clamp(0.0, 1.0),
          curve: Curves.easeOut,
        ),
      ),
    );

    widget.animationController.addStatusListener(_handleAnimationStatus);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
        if (mounted) {
          _shimmerController.repeat();
        }
      });
    }
  }

  @override
  void dispose() {
    widget.animationController.removeStatusListener(_handleAnimationStatus);
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = _isPressed ? _hoverColor : widget.moment.color;
    final textColor = bg == _hoverColor ? Colors.black87 : Colors.white;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _popAnimation,
        _rotationAnimation,
        _glowAnimation,
        _shimmerController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _popAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Opacity(
              opacity: _popAnimation.value.clamp(0.0, 1.0),
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) => setState(() => _isPressed = false),
                onTapCancel: () => setState(() => _isPressed = false),
                onTap: () {
                  context.read<SmartHomeState>().applyMoment(widget.moment);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  );
                },
                child: AnimatedScale(
                  scale: _isPressed ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    curve: Curves.easeOut,
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [bg, bg.withValues(alpha: 0.8)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: _isPressed ? 16 : 12,
                          offset: const Offset(0, 6),
                        ),
                        // Glow effect
                        BoxShadow(
                          color: bg.withValues(
                            alpha: (0.4 * _glowAnimation.value).clamp(0.0, 1.0),
                          ),
                          blurRadius: 20 * _glowAnimation.value,
                          spreadRadius: 3 * _glowAnimation.value,
                        ),
                        // Shimmer highlight
                        BoxShadow(
                          color: Colors.white.withValues(
                            alpha: (0.1 + 0.2 * _shimmerController.value).clamp(
                              0.0,
                              1.0,
                            ),
                          ),
                          blurRadius: 8,
                          offset: Offset(
                            -4 * _shimmerController.value,
                            -4 * _shimmerController.value,
                          ),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha:
                              (0.2 +
                                      0.3 * _glowAnimation.value +
                                      0.1 * _shimmerController.value)
                                  .clamp(0.0, 1.0),
                        ),
                        width: _isPressed ? 2 : 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.moment.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          height: 1.1,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedAddButton extends StatefulWidget {
  final AnimationController animationController;

  const _AnimatedAddButton({required this.animationController});

  @override
  State<_AnimatedAddButton> createState() => _AnimatedAddButtonState();
}

class _AnimatedAddButtonState extends State<_AnimatedAddButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _pulseController;
  late Animation<double> _popAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _popAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Curves.elasticOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: math.pi * 4, end: 0.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    widget.animationController.addStatusListener(_handleCenterAnimationStatus);
  }

  void _handleCenterAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      _pulseController.repeat();
    }
  }

  @override
  void dispose() {
    widget.animationController.removeStatusListener(
      _handleCenterAnimationStatus,
    );
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _popAnimation,
        _rotationAnimation,
        _pulseController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _popAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Opacity(
              // clamp here because Curves.elasticOut can overshoot > 1.0
              opacity: _popAnimation.value.clamp(0.0, 1.0),
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) => setState(() => _isPressed = false),
                onTapCancel: () => setState(() => _isPressed = false),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add new moment coming soon!'),
                      backgroundColor: Color(0xFFB8E6B8),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: AnimatedScale(
                  scale: _isPressed ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    curve: Curves.easeOut,
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFB8E6B8), Color(0xFF90C695)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: _isPressed ? 18 : 14,
                          offset: const Offset(0, 6),
                        ),
                        // Pulsing glow
                        BoxShadow(
                          color: const Color(0xFFB8E6B8).withOpacity(
                            (0.4 + 0.3 * _pulseController.value).clamp(
                              0.0,
                              1.0,
                            ),
                          ),
                          blurRadius: 20 + (10 * _pulseController.value),
                          spreadRadius: 2 + (4 * _pulseController.value),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: (0.3 + 0.2 * _pulseController.value).clamp(
                            0.0,
                            1.0,
                          ),
                        ),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.black87,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
