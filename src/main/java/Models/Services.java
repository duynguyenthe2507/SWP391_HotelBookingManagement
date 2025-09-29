/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Services {

    private int serviceId;
    private String name;
    private double price;
    private String description;
}
