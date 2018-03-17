$fn=36;
difference()
{
    cube(15);
    
    translate([7.5,7.5]) 
    {
        cylinder(r=5,h=20);
    }
    
    translate([16, 7.5, 7.5]) 
    {
        rotate([0,270,0])
        {
            cylinder(r=5,h=20);
        }
    }
    
    translate([7.5, 16, 7.5]) 
    {
        rotate([90,0,0])
        {
            cylinder(r=5,h=20);
        }
    }
    
    translate([7.5,7.5,7.5])
    {
        sphere(r=7.5);
    }
}

    translate([7.5,7.5,7.5])
    {
        sphere(r=6.5);
    }
