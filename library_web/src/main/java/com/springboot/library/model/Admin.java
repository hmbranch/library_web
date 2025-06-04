package com.springboot.library.model;

public class Admin {
    private Integer adminIdx;
    private String adminId;
    private String adminPw;
    private String name;
    
    // 기본 생성자
    public Admin() {}
    
    // 생성자 (로그인용)
    public Admin(String adminId, String adminPw) {
        this.adminId = adminId;
        this.adminPw = adminPw;
    }
    
    // 생성자 (전체)
    public Admin(String adminId, String adminPw, String name) {
        this.adminId = adminId;
        this.adminPw = adminPw;
        this.name = name;
    }
    
    // Getter & Setter
    public Integer getAdminIdx() {
        return adminIdx;
    }
    
    public void setAdminIdx(Integer adminIdx) {
        this.adminIdx = adminIdx;
    }
    
    public String getAdminId() {
        return adminId;
    }
    
    public void setAdminId(String adminId) {
        this.adminId = adminId;
    }
    
    public String getAdminPw() {
        return adminPw;
    }
    
    public void setAdminPw(String adminPw) {
        this.adminPw = adminPw;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    @Override
    public String toString() {
        return "Admin{" +
                "adminIdx=" + adminIdx +
                ", adminId='" + adminId + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}