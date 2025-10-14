package com.OOPWebProject.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.OOPWebProject.dao.ApplianceDAO;
import com.OOPWebProject.dao.RoomDAO;
import com.OOPWebProject.model.Appliance;
import com.OOPWebProject.model.Room;

@WebServlet("/appliances/*")
public class ApplianceController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ApplianceDAO applianceDAO;
    private RoomDAO roomDAO;

    public void init() {
        applianceDAO = new ApplianceDAO();
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
                    listAppliances(request, response);
                    break;
                case "byRoom":
                    listAppliancesByRoom(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteAppliance(request, response);
                    break;
                default:
                    listAppliances(request, response);
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
                    addAppliance(request, response);
                    break;
                case "update":
                    updateAppliance(request, response);
                    break;
                default:
                    listAppliances(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void listAppliances(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Appliance> appliances = applianceDAO.getAllAppliances();
        List<Room> rooms = roomDAO.getAllRooms();
        request.setAttribute("appliances", appliances);
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/appliances.jsp").forward(request, response);
    }

    private void listAppliancesByRoom(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        List<Appliance> appliances = applianceDAO.getAppliancesByRoom(roomId);
        List<Room> rooms = roomDAO.getAllRooms();
        request.setAttribute("appliances", appliances);
        request.setAttribute("rooms", rooms);
        request.setAttribute("selectedRoomId", roomId);
        request.getRequestDispatcher("/appliances.jsp").forward(request, response);
    }

    private void addAppliance(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        String applianceName = request.getParameter("applianceName");
        double wattage = Double.parseDouble(request.getParameter("wattage"));
        String description = request.getParameter("description");

        Appliance appliance = new Appliance(roomId, applianceName, wattage, description);
        applianceDAO.insertAppliance(appliance);
        
        response.sendRedirect(request.getContextPath() + "/appliances?action=list&success=Appliance added successfully");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int applianceId = Integer.parseInt(request.getParameter("id"));
        Appliance appliance = applianceDAO.getApplianceById(applianceId);
        List<Appliance> appliances = applianceDAO.getAllAppliances();
        List<Room> rooms = roomDAO.getAllRooms();
        request.setAttribute("appliance", appliance);
        request.setAttribute("appliances", appliances);
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/appliances.jsp").forward(request, response);
    }

    private void updateAppliance(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int applianceId = Integer.parseInt(request.getParameter("applianceId"));
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        String applianceName = request.getParameter("applianceName");
        double wattage = Double.parseDouble(request.getParameter("wattage"));
        String description = request.getParameter("description");
        String status = request.getParameter("status");

        Appliance appliance = new Appliance(applianceId, roomId, applianceName, wattage, description, status);
        applianceDAO.updateAppliance(appliance);
        
        response.sendRedirect(request.getContextPath() + "/appliances?action=list&success=Appliance updated successfully");
    }

    private void deleteAppliance(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int applianceId = Integer.parseInt(request.getParameter("id"));
        applianceDAO.deleteAppliance(applianceId);
        response.sendRedirect(request.getContextPath() + "/appliances?action=list&success=Appliance deleted successfully");
    }
}
