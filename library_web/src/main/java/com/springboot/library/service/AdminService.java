package com.springboot.library.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.springboot.library.dao.AdminDao;
import com.springboot.library.model.Admin;

@Service
public class AdminService {
    
    @Autowired
    private AdminDao adminDAO;
    
    // 관리자 로그인
    public Admin login(String adminId, String adminPw) {
        try {
            Admin admin = adminDAO.findByAdminIdAndPassword(adminId, adminPw);
            return admin;
        } catch (Exception e) {
            System.out.println("관리자 로그인 오류: " + e.getMessage());
            return null;
        }
    }
    
    // 관리자 정보 조회
    public Admin getAdminById(String adminId) {
        try {
            return adminDAO.findByAdminId(adminId);
        } catch (Exception e) {
            System.out.println("관리자 정보 조회 오류: " + e.getMessage());
            return null;
        }
    }
    
    // 관리자 정보 조회 (IDX로)
    public Admin getAdminByIdx(Integer adminIdx) {
        try {
            return adminDAO.findByAdminIdx(adminIdx);
        } catch (Exception e) {
            System.out.println("관리자 정보 조회 오류: " + e.getMessage());
            return null;
        }
    }
}