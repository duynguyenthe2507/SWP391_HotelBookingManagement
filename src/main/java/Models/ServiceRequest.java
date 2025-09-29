/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ServiceRequest {

    private int serviceId;
    private int bookingId;
    private int serviceTypeId;
    private double price;
    private String status;
}
