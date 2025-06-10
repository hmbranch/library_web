package com.springboot.library.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.library.model.Admin;
@Mapper
public interface AdminDao {
	  // 관리자 로그인
    Admin findByAdminIdAndPassword(@Param("adminId") String adminId, @Param("adminPw") String adminPw);
    
    // 관리자 정보 조회 (ID로)
    Admin findByAdminId(@Param("adminId") String adminId);
    
    // 관리자 정보 조회 (IDX로)
    Admin findByAdminIdx(@Param("adminIdx") Integer adminIdx);
}
