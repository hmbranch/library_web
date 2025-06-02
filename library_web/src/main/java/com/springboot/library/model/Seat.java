package com.springboot.library.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Seat {
    private Integer seatId;              // 좌석 ID (1~10)
    private String seatName;             // 좌석 이름 (A1, A2, B1, B2 등)
    private Boolean isOccupied;          // 사용 중 여부
    private Boolean arduinoSignal;       // 아두이노 센서 신호
    private String userId;               // 예약한 사용자 ID
    private Date reservationStart;       // 예약 시작 시간 (Date 타입으로 변경)
    private Date reservationEnd;         // 예약 종료 시간 (Date 타입으로 변경)
    private Date lastUpdated;            // 마지막 업데이트 시간 (Date 타입으로 변경)
    
    // 좌석 상태를 확인하는 편의 메소드들
    public boolean isAvailable() {
        return !isOccupied && !arduinoSignal;
    }
    
    public boolean isReserved() {
        return isOccupied && userId != null;
    }
    
    public boolean hasArduinoDetection() {
        return arduinoSignal != null && arduinoSignal;
    }
    
    // 좌석 상태를 문자열로 반환
    public String getStatusText() {
        if (isAvailable()) {
            return "사용 가능";
        } else if (isReserved()) {
            return "예약됨";
        } else if (hasArduinoDetection()) {
            return "사용 중";
        } else {
            return "점검 중";
        }
    }
    
    // CSS 클래스명 반환 (화면 표시용)
    public String getStatusClass() {
        if (isAvailable()) {
            return "available";
        } else if (isReserved()) {
            return "reserved";
        } else if (hasArduinoDetection()) {
            return "occupied";
        } else {
            return "maintenance";
        }
    }
}