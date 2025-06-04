package com.springboot.library.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.springboot.library.model.Admin;
import com.springboot.library.model.Seat;
import com.springboot.library.service.AdminService;
import com.springboot.library.service.SeatService;

import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {
    
    @Autowired
    private AdminService adminService;
    
    @Autowired
    private SeatService seatService;
    
    // 관리자 메인 페이지
    @GetMapping("")
    public ModelAndView adminHome(HttpSession session) {
        Admin loginAdmin = (Admin) session.getAttribute("loginAdmin");
        
        if (loginAdmin == null) {
            return new ModelAndView("redirect:/admin/login");
        }
        
        // 좌석 통계 및 전체 좌석 정보 조회
        SeatService.SeatStats stats = seatService.getSeatStats();
        List<Seat> allSeats = seatService.getAllSeats();
        
        // 만료된 예약 자동 정리
        seatService.clearExpiredReservations();
        
        ModelAndView mav = new ModelAndView("admin/index");
        mav.addObject("loginAdmin", loginAdmin);
        mav.addObject("stats", stats);
        mav.addObject("seats", allSeats);
        
        return mav;
    }
    
    // 관리자 로그인 페이지
    @GetMapping("/login")
    public ModelAndView loginPage() {
        ModelAndView mav = new ModelAndView("admin/login");
        return mav;
    }
    
    // 관리자 로그인 처리
    @PostMapping("/login")
    public ModelAndView loginProcess(@RequestParam String adminId, 
                                   @RequestParam String adminPw, 
                                   HttpSession session) {
        
        Admin admin = adminService.login(adminId, adminPw);
        
        if (admin != null) {
            // 로그인 성공
            session.setAttribute("loginAdmin", admin);
            return new ModelAndView("redirect:/admin");
        } else {
            // 로그인 실패
            ModelAndView mav = new ModelAndView("admin/login");
            mav.addObject("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return mav;
        }
    }
    
    // 관리자 로그아웃
    @GetMapping("/logout")
    public ModelAndView logout(HttpSession session) {
        session.invalidate();
        return new ModelAndView("redirect:/admin/login");
    }
    
    // 좌석 강제 취소 (관리자용)
    @PostMapping("/cancel-seat")
    public ModelAndView cancelSeat(@RequestParam Integer seatId, HttpSession session) {
        Admin loginAdmin = (Admin) session.getAttribute("loginAdmin");
        
        if (loginAdmin == null) {
            return new ModelAndView("redirect:/admin/login");
        }
        
        boolean success = seatService.cancelReservation(seatId);
        
        if (success) {
            System.out.println("관리자 " + loginAdmin.getName() + "이(가) 좌석 " + seatId + " 예약을 취소했습니다.");
            return new ModelAndView("redirect:/admin?success=cancelled");
        } else {
            return new ModelAndView("redirect:/admin?error=cancel_failed");
        }
    }
    
    // 모든 만료된 예약 정리 (관리자용)
    @PostMapping("/clear-expired")
    public ModelAndView clearExpiredReservations(HttpSession session) {
        Admin loginAdmin = (Admin) session.getAttribute("loginAdmin");
        
        if (loginAdmin == null) {
            return new ModelAndView("redirect:/admin/login");
        }
        
        seatService.clearExpiredReservations();
        System.out.println("관리자 " + loginAdmin.getName() + "이(가) 만료된 예약을 정리했습니다.");
        
        return new ModelAndView("redirect:/admin?success=cleared");
    }
}