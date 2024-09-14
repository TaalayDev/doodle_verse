import '../../data.dart';
import 'brushes.dart' as b;
import 'figures.dart' as f;

class ToolsManager {
  static final ToolsManager _instance = ToolsManager._internal();
  factory ToolsManager() => _instance;
  ToolsManager._internal();

  final List<BrushData> _brushes = [];
  final List<BrushData> _figures = [];
  final BrushData eraser = b.eraser;
  late final BrushData pencil;
  late final BrushData defaultBrush;

  List<BrushData> get brushes => _brushes;
  List<BrushData> get figures => _figures;
  List<BrushData> get allTools => [
        ..._brushes,
        ..._figures,
        eraser,
      ];

  BrushData getBrush(int id) {
    return allTools.firstWhere((element) => element.id == id);
  }

  Future<void> loadTools() async {
    pencil = await b.pencil;
    defaultBrush = b.defaultBrush;
    _brushes.addAll([
      defaultBrush,
      pencil,
      b.softPencilBrush,
      b.hardPencilBrush,
      b.sketchyPencilBrush,
      b.coloredPencilBrush,
      await b.marker,
      b.watercolor,
      b.crayon,
      b.sprayPaint,
      b.neon,
      b.charcoal,
      b.sketchy,
      b.star,
      b.heart,
      b.bubbleBrush,
      b.glitterBrush,
      b.rainbowBrush,
      b.sparkleBrush,
      b.leafBrush,
      b.grassBrush,
      b.pixelBrush,
      b.glowBrush,
      b.mosaicBrush,
      b.splatBrush,
      b.calligraphyBrush,
      b.electricBrush,
      b.furBrush,
      b.galaxyBrush,
      b.fractalBrush,
      b.fireBrush,
      b.snowflakeBrush,
      b.cloudBrush,
      b.lightningBrush,
      b.featherBrush,
      b.galaxyBrush,
      b.confettiBrush,
      b.metallicBrush,
      b.embroideryBrush,
      b.stainedGlassBrush,
      b.ribbonBrush,
      b.particleFieldBrush,
      b.inkBrush,
      b.fireworksBrush,
      b.embossBrush,
      b.glassBrush,
    ]);

    _figures.addAll([
      f.rectangleTool,
      f.circleTool,
      f.lineTool,
      f.triangleTool,
      f.arrowTool,
      f.ellipseTool,
      f.polygonTool,
      f.starTool,
      f.heartTool,
      f.spiralTool,
      f.cloudTool,
      f.lightningTool,
      f.pentagonTool,
      f.hexagonTool,
      f.parallelogramTool,
      f.trapezoidTool,
    ]);
  }
}
