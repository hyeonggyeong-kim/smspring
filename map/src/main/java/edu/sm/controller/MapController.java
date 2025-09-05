package edu.sm.controller;

import edu.sm.app.dto.Marker;
import edu.sm.app.service.MarkerService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Random;

@Controller
@Slf4j
@RequestMapping("/map")
@RequiredArgsConstructor
public class MapController {

    private final MarkerService markerService;
    private final String dir = "map/";

    /* ------- View 라우팅 ------- */
    @GetMapping("")
    public String main(Model model) {
        model.addAttribute("center", dir + "center");
        model.addAttribute("left",   dir + "left");
        return "index";
    }

    @GetMapping("/go")
    public String go(Model model, @RequestParam("target") int target) throws Exception {
        Marker marker = markerService.get(target);
        model.addAttribute("marker", marker);
        model.addAttribute("center", dir + "go");
        model.addAttribute("left",   dir + "left");
        return "index";
    }

    @GetMapping("/map")
    public String map(Model model) {
        model.addAttribute("center", dir + "map");
        model.addAttribute("left",   dir + "left");
        return "index";
    }

    @GetMapping("/api/nearby")
    @ResponseBody
    public ResponseEntity<List<Marker>> nearby(
            @RequestParam double lat,
            @RequestParam double lng,
            @RequestParam(defaultValue = "3") double radiusKm,
            @RequestParam(required = false) Integer limit
    ) throws Exception {
        List<Marker> list = markerService.findWithinRadius(lat, lng, radiusKm, limit);
        log.info("nearby lat={}, lng={}, r={}, result={}", lat, lng, radiusKm, list.size());
        return ResponseEntity.ok(list);
    }

    @GetMapping("/api/marker")
    @ResponseBody
    public ResponseEntity<Marker> one(@RequestParam int target) throws Exception {
        return ResponseEntity.ok(markerService.get(target));
    }

    @GetMapping("/api/bike/step")
    @ResponseBody
    public ResponseEntity<Map<String, Double>> bikeStep(
            @RequestParam double lat,
            @RequestParam double lng
    ) {
        Random r = new Random();
        // 약 5~15m 이동 (위경도 대략 0.00005~0.00015deg)
        double dLat = (r.nextBoolean() ? 1 : -1) * (0.00005 + r.nextDouble() * 0.00010);
        double dLng = (r.nextBoolean() ? 1 : -1) * (0.00005 + r.nextDouble() * 0.00010);
        return ResponseEntity.ok(Map.of("lat", lat + dLat, "lng", lng + dLng));
    }
}
