<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 대시보드 - 도서관 관리 시스템</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>
    <div class="admin-header">
        <h1>🔧 관리자 대시보드</h1>
        <div class="admin-info">
            <span>관리자: <strong>${loginAdmin.name}</strong>님</span>
            <a href="/admin/logout" class="admin-logout-btn">로그아웃</a>
        </div>
    </div>
    
    <div class="admin-container">
        <!-- 알림 메시지 -->
        <c:if test="${param.success == 'cancelled'}">
            <div class="alert alert-success">
                <span>✅</span>
                좌석 예약이 성공적으로 취소되었습니다.
            </div>
        </c:if>
        
        <c:if test="${param.success == 'cleared'}">
            <div class="alert alert-success">
                <span>✅</span>
                만료된 예약이 성공적으로 정리되었습니다.
            </div>
        </c:if>
        
        <c:if test="${param.error == 'cancel_failed'}">
            <div class="alert alert-error">
                <span>⚠️</span>
                좌석 예약 취소에 실패했습니다.
            </div>
        </c:if>
        
        <!-- 통계 정보 -->
        <div class="admin-stats-bar">
            <div class="stat-item">
                <span class="stat-label">전체 좌석</span>
                <span class="stat-value total">${stats.totalSeats}</span>
            </div>
            <div class="stat-item">
                <span class="stat-label">사용 중</span>
                <span class="stat-value occupied">${stats.occupiedSeats}</span>
            </div>
            <div class="stat-item">
                <span class="stat-label">이용 가능</span>
                <span class="stat-value available">${stats.availableSeats}</span>
            </div>
        </div>
        
        <!-- 관리 기능 -->
        <div class="admin-actions">
            <h2>🛠️ 관리 기능</h2>
            <div class="action-buttons">
                <form method="post" action="/admin/clear-expired" style="display: inline;">
                    <button type="submit" class="admin-btn admin-btn-warning" 
                            onclick="return confirm('만료된 예약을 모두 정리하시겠습니까?')">
                        <span class="btn-icon">🧹</span>
                        만료된 예약 정리
                    </button>
                </form>
                
                <button onclick="location.reload()" class="admin-btn admin-btn-info">
                    <span class="btn-icon">🔄</span>
                    새로고침
                </button>
            </div>
        </div>
        
        <!-- 좌석 현황 테이블 -->
        <div class="seat-management">
            <h2>📋 좌석 현황 관리</h2>
            
            <div class="table-container">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>좌석 번호</th>
                            <th>상태</th>
                            <th>예약자</th>
                            <th>예약 시작</th>
                            <th>예약 종료</th>
                            <th>아두이노 신호</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="seat" items="${seats}">
                            <tr class="seat-row ${seat.isOccupied ? 'occupied' : 'available'}">
                                <td class="seat-number">${seat.seatName}</td>
                                <td class="seat-status">
                                    <span class="status-badge ${seat.statusClass}">
                                        ${seat.statusText}
                                    </span>
                                </td>
                                <td class="seat-user">
                                    <c:choose>
                                        <c:when test="${not empty seat.userId}">
                                            ${seat.userId}
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="seat-start">
                                    <c:choose>
                                        <c:when test="${not empty seat.reservationStart}">
                                            <fmt:formatDate value="${seat.reservationStart}" pattern="MM-dd HH:mm"/>
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="seat-end">
                                    <c:choose>
                                        <c:when test="${not empty seat.reservationEnd}">
                                            <fmt:formatDate value="${seat.reservationEnd}" pattern="MM-dd HH:mm"/>
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="seat-signal">
                                    <span class="signal-badge ${seat.arduinoSignal ? 'active' : 'inactive'}">
                                        ${seat.arduinoSignal ? 'ON' : 'OFF'}
                                    </span>
                                </td>
                                <td class="seat-actions">
                                    <c:if test="${seat.isOccupied}">
                                        <form method="post" action="/admin/cancel-seat" style="display: inline;">
                                            <input type="hidden" name="seatId" value="${seat.seatId}">
                                            <button type="submit" class="admin-btn admin-btn-danger admin-btn-sm" 
                                                    onclick="return confirm('좌석 ${seat.seatName} 예약을 취소하시겠습니까?')">
                                                <span class="btn-icon">❌</span>
                                                취소
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- 푸터 -->
        <div class="admin-footer">
            <p>📞 시스템 문의: 032-123-4567 | 🕒 관리자 근무시간: 09:00 - 22:00</p>
        </div>
    </div>
    
    <script>
        // 자동 새로고침 (10초마다)
        setInterval(function() {
            location.reload();
        }, 10000);
        
        // 현재 시간 표시
        function updateTime() {
            const now = new Date();
            const timeString = now.toLocaleString('ko-KR');
            document.title = `관리자 대시보드 - ${timeString}`;
        }
        
        updateTime();
        setInterval(updateTime, 1000);
    </script>
</body>
</html>