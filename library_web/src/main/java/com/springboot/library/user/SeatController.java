package com.springboot.library.user;

import com.springboot.library.model.Seat;
import com.springboot.library.model.User;
import com.springboot.library.service.SeatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/seats")
public class SeatController {
    
    @Autowired
    private SeatService seatService;
    
    // 좌석 현황 페이지
    @GetMapping("")
    public ModelAndView seatStatus(HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return new ModelAndView("redirect:/library/login");
        }
        
        List<Seat> allSeats = seatService.getAllSeats();
        SeatService.SeatStats stats = seatService.getSeatStats();
        
        ModelAndView mav = new ModelAndView("seat/status");
        mav.addObject("loginUser", loginUser);
        mav.addObject("seats", allSeats);
        mav.addObject("stats", stats);
        System.out.println("테스트중!테스트중!");
        return mav;
    }
    
    // 좌석 예약 페이지
    @GetMapping("/reservation")
    public ModelAndView reservationPage(HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return new ModelAndView("redirect:/library/login");
        }
        
        List<Seat> availableSeats = seatService.getAvailableSeats();
        
        ModelAndView mav = new ModelAndView("seat/reservation");
        mav.addObject("loginUser", loginUser);
        mav.addObject("availableSeats", availableSeats);
        
        return mav;
    }
    
    // 좌석 예약 처리
    @PostMapping("/reserve")
    public ModelAndView reserveSeat(@RequestParam Integer seatId, 
                                   @RequestParam Integer hours,
                                   HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return new ModelAndView("redirect:/library/login");
        }
        
        System.out.println("예약 시도: 사용자=" + loginUser.getUserId() + ", 좌석=" + seatId + ", 시간=" + hours);
        
        boolean success = seatService.reserveSeat(seatId, loginUser.getUserId(), hours);
        
        if (success) {
            System.out.println("예약 성공!");
            return new ModelAndView("redirect:/seats?success=reserved");
        } else {
            System.out.println("예약 실패!");
            ModelAndView mav = new ModelAndView("seat/reservation");
            mav.addObject("loginUser", loginUser);
            mav.addObject("availableSeats", seatService.getAvailableSeats());
            mav.addObject("error", "좌석 예약에 실패했습니다. 이미 예약된 좌석이거나 다른 문제가 발생했습니다.");
            return mav;
        }
    }
    
    // 좌석 예약 취소
    @PostMapping("/cancel")
    public ModelAndView cancelReservation(@RequestParam Integer seatId, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return new ModelAndView("redirect:/library/login");
        }
        
        boolean success = seatService.cancelReservation(seatId);
        
        if (success) {
            return new ModelAndView("redirect:/seats?success=cancelled");
        } else {
            return new ModelAndView("redirect:/seats?error=cancel_failed");
        }
    }
    
    // 아두이노 신호 업데이트 API (REST API)
    @PostMapping("/api/arduino/update")
    @ResponseBody
    public String updateArduinoSignal(@RequestParam Integer seatId, 
                                     @RequestParam Boolean signal) {
        try {
            boolean success = seatService.updateArduinoSignal(seatId, signal);
            if (success) {
                return "{\"status\":\"success\",\"message\":\"Signal updated\"}";
            } else {
                return "{\"status\":\"error\",\"message\":\"Failed to update signal\"}";
            }
        } catch (Exception e) {
            return "{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}";
        }
    }
}