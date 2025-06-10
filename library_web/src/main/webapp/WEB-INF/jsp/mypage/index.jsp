<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 예약 - 도서관 시스템</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">
</head>
<body>
    <div class="header">
        <h1>📚 도서관 관리 시스템</h1>
        <div class="user-info">
            <span>안녕하세요, <strong>${loginUser.name}</strong>님!</span>
            <a href="/library/logout" class="logout-btn">로그아웃</a>
        </div>
    </div>
    
    <div class="container">
        <div class="page-header">
            <h2>👤 내 예약</h2>
            <div class="nav-buttons">
                <a href="/seats" class="btn btn-secondary">좌석 현황</a>
                <a href="/seats/reservation" class="btn btn-primary">새 예약</a>
                <a href="/library" class="btn btn-secondary">홈으로</a>
            </div>
        </div>
        
        <!-- 성공/실패 메시지 -->
        <c:if test="${param.success == 'cancelled'}">
            <div class="alert alert-success">
                ✅ 예약이 성공적으로 취소되었습니다!
            </div>
        </c:if>
        
        <c:if test="${param.success == 'extended'}">
            <div class="alert alert-success">
                ✅ 예약이 성공적으로 연장되었습니다!
            </div>
        </c:if>
        
        <c:if test="${param.error == 'cancel_failed'}">
            <div class="alert alert-error">
                ❌ 예약 취소에 실패했습니다.
            </div>
        </c:if>
        
        <c:if test="${param.error == 'extend_failed'}">
            <div class="alert alert-error">
                ❌ 예약 연장에 실패했습니다.
            </div>
        </c:if>
        
        <c:if test="${param.error == 'not_your_reservation'}">
            <div class="alert alert-error">
                ❌ 본인의 예약이 아닙니다.
            </div>
        </c:if>
        
        <!-- 사용자 정보 -->
        <div class="user-profile">
            <div class="profile-header">
                <div class="profile-icon">👤</div>
                <div class="profile-info">
                    <h3>${loginUser.name} 님의 정보</h3>
                    <p>아이디: ${loginUser.userId}</p>
                </div>
            </div>
        </div>
        
        <!-- 현재 예약 현황 -->
        <div class="reservation-section">
            <h3>🎫 현재 예약 현황</h3>
            
            <c:choose>
                <c:when test="${empty myReservations}">
                    <div class="no-reservation">
                        <div class="no-reservation-icon">📅</div>
                        <h4>현재 예약된 좌석이 없습니다</h4>
                        <p>좌석을 예약하여 도서관을 이용해보세요!</p>
                        <a href="/seats/reservation" class="btn btn-primary">좌석 예약하기</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="reservation-list">
                        <c:forEach items="${myReservations}" var="reservation">
                            <div class="reservation-card">
                                <div class="reservation-header">
                                    <div class="seat-info">
                                        <span class="seat-number">${reservation.seatName}</span>
                                        <span class="seat-status ${reservation.statusClass}">${reservation.statusText}</span>
                                    </div>
                                    <div class="arduino-status">
                                        <c:choose>
                                            <c:when test="${reservation.arduinoSignal}">
                                                <span class="status-indicator active">🟢 사용 중</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-indicator inactive">🔴 비어있음</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <div class="reservation-details">
                                    <div class="time-info">
                                        <div class="time-item">
                                            <span class="time-label">예약 시작:</span>
                                            <span class="time-value">
											    <fmt:formatDate value="${reservation.reservationStart}" pattern="yyyy년 M월 d일 HH:mm"/>
											</span>

                                        </div>
                                        <div class="time-item">
                                            <span class="time-label">예약 종료:</span>
                                            <span class="time-value">
											    <fmt:formatDate value="${reservation.reservationEnd}" pattern="yyyy년 M월 d일 HH:mm"/>
											</span>

                                        </div>
                                    </div>
                                    
                                    <!-- 남은 시간 계산 및 표시 -->
                                    <div class="remaining-time" id="remaining_${reservation.seatId}">
                                        <span class="remaining normal">⏱️ 예약 활성</span>
                                    </div>
                                </div>
                                
                                <div class="reservation-actions">
                                    <!-- 예약 연장 -->
                                    <form method="post" action="/mypage/extend" class="inline-form">
                                        <input type="hidden" name="seatId" value="${reservation.seatId}">
                                        <select name="additionalHours" class="extend-select">
                                            <option value="1">1시간 연장</option>
                                            <option value="2">2시간 연장</option>
                                            <option value="3">3시간 연장</option>
                                            <option value="4">4시간 연장</option>
                                        </select>
                                        <button type="submit" class="btn btn-extend" onclick="return confirm('예약을 연장하시겠습니까?')">
                                            ⏱️ 연장
                                        </button>
                                    </form>
                                    
                                    <!-- 예약 취소 -->
                                    <form method="post" action="/mypage/cancel" class="inline-form">
                                        <input type="hidden" name="seatId" value="${reservation.seatId}">
                                        <button type="submit" class="btn btn-cancel" onclick="return confirm('정말로 예약을 취소하시겠습니까?')">
                                            🗑️ 취소
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- 이용 안내 -->
        <div class="usage-guide">
            <h3>📋 이용 안내</h3>
            <div class="guide-grid">
                <div class="guide-item">
                    <div class="guide-icon">⏰</div>
                    <div class="guide-content">
                        <h4>예약 시간</h4>
                        <p>최대 4시간까지 예약 가능하며, 최대 4시간까지 연장할 수 있습니다.</p>
                    </div>
                </div>
                <div class="guide-item">
                    <div class="guide-icon">📡</div>
                    <div class="guide-content">
                        <h4>센서 확인</h4>
                        <p>아두이노 센서로 실제 착석 여부를 확인합니다. 장시간 자리를 비우지 마세요.</p>
                    </div>
                </div>
                <div class="guide-item">
                    <div class="guide-icon">🔄</div>
                    <div class="guide-content">
                        <h4>예약 관리</h4>
                        <p>예약 연장은 현재 예약이 끝나기 전에만 가능합니다.</p>
                    </div>
                </div>
                <div class="guide-item">
                    <div class="guide-icon">👥</div>
                    <div class="guide-content">
                        <h4>예약 제한</h4>
                        <p>1인당 1개의 좌석만 예약할 수 있습니다.</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 자동 새로고침 안내 -->
        <div class="auto-refresh">
            <span id="lastUpdate">마지막 업데이트: <span id="updateTime">--:--:--</span></span>
            <button id="refreshBtn" class="btn btn-small">🔄 새로고침</button>
        </div>
    </div>
    
    <script>
        // 페이지 로드시 시간 업데이트
        document.getElementById('updateTime').textContent = new Date().toLocaleTimeString();
        
        // 새로고침 버튼 이벤트
        document.getElementById('refreshBtn').addEventListener('click', function() {
            location.reload();
        });
        
        // 30초마다 자동 새로고침
        setInterval(function() {
            location.reload();
        }, 30000);
    </script>
</body>
</html>