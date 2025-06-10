package com.springboot.library.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import com.springboot.library.service.SeatService;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class ApiController {
    
    @Autowired
    private SeatService seatService;
    
    @PostMapping("/seat")
    public ResponseEntity<String> receiveSeatStatus(@RequestBody Map<String, String> data) {
        try {
            String status = data.get("status");
            String seatIdStr = data.get("seatId"); // 아두이노에서 좌석 ID도 함께 보내야 함
            
            System.out.println("💡 받은 좌석 상태: " + status + ", 좌석 ID: " + seatIdStr);
            
            // 좌석 ID 파싱
            Integer seatId = null;
            if (seatIdStr != null) {
                seatId = Integer.parseInt(seatIdStr);
            } else {
                // 좌석 ID가 없으면 기본값 사용 (예: 1번 좌석)
                seatId = 1;
                System.out.println("⚠️ 좌석 ID가 없어서 기본값 1 사용");
            }
            
            // 문자열을 boolean으로 변환
            boolean arduinoSignal = false;
            if (status != null) {
                if (status.contains("좌석 사용중") || status.equalsIgnoreCase("occupied") || status.equalsIgnoreCase("on")) {
                    arduinoSignal = true;
                } else if (status.contains("좌석 비어있음") || status.equalsIgnoreCase("available") || status.equalsIgnoreCase("off")) {
                    arduinoSignal = false;
                }
            }
            
            System.out.println("🔄 아두이노 신호 업데이트: 좌석 " + seatId + " = " + (arduinoSignal ? "ON" : "OFF"));
            
            // SeatService를 통해 아두이노 신호 업데이트
            boolean success = seatService.updateArduinoSignal(seatId, arduinoSignal);
            
            if (success) {
                System.out.println("✅ 아두이노 신호 업데이트 성공");
                return ResponseEntity.ok("상태 수신 및 업데이트 완료");
            } else {
                System.out.println("❌ 아두이노 신호 업데이트 실패");
                return ResponseEntity.badRequest().body("상태 업데이트 실패");
            }
            
        } catch (Exception e) {
            System.out.println("❌ 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("서버 오류: " + e.getMessage());
        }
    }
    
    // 여러 좌석의 상태를 한번에 받는 API (옵션)
    @PostMapping("/seats/bulk")
    public ResponseEntity<String> receiveBulkSeatStatus(@RequestBody Map<String, Object> data) {
        try {
            System.out.println("💡 여러 좌석 상태 수신: " + data);
            
            // 예시: {"seats": [{"seatId": 1, "status": "사용중"}, {"seatId": 2, "status": "비어있음"}]}
            if (data.containsKey("seats")) {
                @SuppressWarnings("unchecked")
                java.util.List<Map<String, Object>> seats = (java.util.List<Map<String, Object>>) data.get("seats");
                
                for (Map<String, Object> seatData : seats) {
                    Integer seatId = Integer.parseInt(seatData.get("seatId").toString());
                    String status = seatData.get("status").toString();
                    
                    boolean arduinoSignal = false;
                    if (status.contains("사용중") || status.equalsIgnoreCase("occupied")) {
                        arduinoSignal = true;
                    }
                    
                    seatService.updateArduinoSignal(seatId, arduinoSignal);
                    System.out.println("🔄 좌석 " + seatId + " 신호 업데이트: " + (arduinoSignal ? "ON" : "OFF"));
                }
            }
            
            return ResponseEntity.ok("모든 좌석 상태 업데이트 완료");
            
        } catch (Exception e) {
            System.out.println("❌ 여러 좌석 업데이트 오류: " + e.getMessage());
            return ResponseEntity.internalServerError().body("서버 오류: " + e.getMessage());
        }
    }
}