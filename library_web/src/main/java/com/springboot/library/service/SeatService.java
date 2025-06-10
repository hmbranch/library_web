package com.springboot.library.service;

import com.springboot.library.mapper.SeatMapper;
import com.springboot.library.model.Seat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class SeatService {
    
    @Autowired
    private SeatMapper seatMapper;
    
    // 모든 좌석 조회
    public List<Seat> getAllSeats() {
        return seatMapper.findAllSeats();
    }
    
    // 특정 좌석 조회
    public Seat getSeatById(Integer seatId) {
        return seatMapper.findBySeatId(seatId);
    }
    
    // 사용 가능한 좌석만 조회
    public List<Seat> getAvailableSeats() {
        return seatMapper.findAvailableSeats();
    }
    
    // 좌석 예약
    public boolean reserveSeat(Integer seatId, String userId, Integer hours) {
        try {
            // 먼저 해당 좌석이 예약 가능한지 확인
            Seat seat = seatMapper.findBySeatId(seatId);
            if (seat == null) {
                System.out.println("좌석을 찾을 수 없습니다: " + seatId);
                return false;
            }
            
            if (seat.getIsOccupied() || seat.getArduinoSignal()) {
                System.out.println("이미 사용 중인 좌석입니다: " + seatId);
                return false;
            }
            
            // 사용자가 이미 다른 좌석을 예약했는지 확인
            List<Seat> userReservations = seatMapper.findByUserId(userId);
            if (!userReservations.isEmpty()) {
                System.out.println("사용자가 이미 다른 좌석을 예약했습니다: " + userId);
                return false;
            }
            
            int result = seatMapper.reserveSeat(seatId, userId, hours);
            if (result > 0) {
                System.out.println("좌석 예약 성공: 좌석" + seatId + ", 사용자" + userId + ", " + hours + "시간");
                return true;
            } else {
                System.out.println("좌석 예약 실패: DB 업데이트 결과 0");
                return false;
            }
        } catch (Exception e) {
            System.out.println("좌석 예약 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // 좌석 예약 해제
    public boolean cancelReservation(Integer seatId) {
        try {
            int result = seatMapper.cancelReservation(seatId);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 아두이노 신호 업데이트 (외부 API에서 호출)
    public boolean updateArduinoSignal(Integer seatId, Boolean signal) {
        try {
            int result = seatMapper.updateArduinoSignal(seatId, signal);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 사용자별 예약 좌석 조회
    public List<Seat> getUserReservations(String userId) {
        return seatMapper.findByUserId(userId);
    }
    
    // 예약 연장
    public boolean extendReservation(Integer seatId, String userId, Integer additionalHours) {
        try {
            // 최대 8시간까지만 연장 가능하도록 제한 (원래 4시간 + 연장 4시간)
            if (additionalHours > 4) {
                System.out.println("연장 시간이 너무 깁니다: " + additionalHours);
                return false;
            }
            
            int result = seatMapper.extendReservation(seatId, userId, additionalHours);
            if (result > 0) {
                System.out.println("예약 연장 성공: 좌석" + seatId + ", " + additionalHours + "시간 연장");
                return true;
            } else {
                System.out.println("예약 연장 실패: DB 업데이트 결과 0");
                return false;
            }
        } catch (Exception e) {
            System.out.println("예약 연장 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // 만료된 예약 정리
    public int clearExpiredReservations() {
        try {
            int result = seatMapper.clearExpiredReservations();
            if (result > 0) {
                System.out.println("만료된 예약 " + result + "개를 정리했습니다.");
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    // 좌석 현황 통계
    public SeatStats getSeatStats() {
        List<Seat> allSeats = getAllSeats();
        
        long totalSeats = allSeats.size();
        long availableSeats = allSeats.stream().filter(Seat::isAvailable).count();
        long occupiedSeats = allSeats.stream().filter(seat -> seat.getIsOccupied() || seat.getArduinoSignal()).count();
        
        return new SeatStats(totalSeats, availableSeats, occupiedSeats);
    }
    
    // 좌석 통계 내부 클래스
    public static class SeatStats {
        private final long totalSeats;
        private final long availableSeats;
        private final long occupiedSeats;
        
        public SeatStats(long totalSeats, long availableSeats, long occupiedSeats) {
            this.totalSeats = totalSeats;
            this.availableSeats = availableSeats;
            this.occupiedSeats = occupiedSeats;
        }
        
        public long getTotalSeats() { return totalSeats; }
        public long getAvailableSeats() { return availableSeats; }
        public long getOccupiedSeats() { return occupiedSeats; }
    }
}