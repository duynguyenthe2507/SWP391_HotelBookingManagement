package Controller;

import DAL.RoomDao;
import Models.Room;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet(name="RoomController", urlPatterns={"/RoomController"})
public class GuestGetAllRooms extends HttpServlet {
    
    public final RoomDao roomDao = new RoomDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        List<Room> roomList = roomDao.getAll();
        
    } 


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    }
}
