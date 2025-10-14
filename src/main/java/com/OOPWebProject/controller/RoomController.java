package com.OOPWebProject.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.OOPWebProject.dao.RoomDAO;
import com.OOPWebProject.model.Room;
import com.OOPWebProject.model.User;

@WebServlet("/rooms/*")
public class RoomController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RoomDAO roomDAO;

    public void init() {
        roomDAO = new RoomDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list":
                    listRooms(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteRoom(request, response);
                    break;
                default:
                    listRooms(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "add":
                    addRoom(request, response);
                    break;
                case "update":
                    updateRoom(request, response);
                    break;
                default:
                    listRooms(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void listRooms(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Room> rooms = roomDAO.getAllRooms();
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/rooms.jsp").forward(request, response);
    }

    private void addRoom(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String roomName = request.getParameter("roomName");
        String occupantName = request.getParameter("occupantName");
        String floorNumberStr = request.getParameter("floorNumber");
        String status = request.getParameter("status");

        if (roomName == null || roomName.trim().isEmpty()) {
            request.setAttribute("error", "Room name is required");
            listRooms(request, response);
            return;
        }

        int floorNumber = floorNumberStr != null ? Integer.parseInt(floorNumberStr) : 1;
        
        Room room = new Room(roomName, occupantName, floorNumber);
        if (status != null && !status.isEmpty()) {
            room.setStatus(status);
        }
        
        roomDAO.insertRoom(room);
        response.sendRedirect(request.getContextPath() + "/rooms?action=list&success=Room added successfully");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int roomId = Integer.parseInt(request.getParameter("id"));
        Room room = roomDAO.getRoomById(roomId);
        request.setAttribute("room", room);
        List<Room> rooms = roomDAO.getAllRooms();
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/rooms.jsp").forward(request, response);
    }

    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        String roomName = request.getParameter("roomName");
        String occupantName = request.getParameter("occupantName");
        int floorNumber = Integer.parseInt(request.getParameter("floorNumber"));
        String status = request.getParameter("status");

        Room room = new Room(roomId, roomName, occupantName, null, floorNumber, status);
        roomDAO.updateRoom(room);
        
        response.sendRedirect(request.getContextPath() + "/rooms?action=list&success=Room updated successfully");
    }

    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int roomId = Integer.parseInt(request.getParameter("id"));
        roomDAO.deleteRoom(roomId);
        response.sendRedirect(request.getContextPath() + "/rooms?action=list&success=Room deleted successfully");
    }
}
