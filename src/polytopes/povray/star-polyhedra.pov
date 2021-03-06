// Persistence of Vision Ray Tracer Scene Description File
// Vers: 3.7
// Date: 2018/04/22
// Auth: Zhao Liang mathzhaoliang@gmail.com
// Note: this scene file is used for rendering 3d polyhedron

#version 3.7;

#include "colors.inc"

global_settings {
    assumed_gamma 2.2
}

background { White }

#declare vertex_size = 0.035;
#declare edge_size = 0.020;
#declare face_filter = 0.1;

#declare vertex_color = Black * 0.05;
#declare edge_colors = array[3] { Orange, Orange, Orange };
#declare face_colors = array[3] { Yellow, Red, SkyBlue };

#declare edge_finish = finish {
    ambient 0.2
    diffuse 0.5
    reflection 0.1
    specular 3
    roughness 0.003
}

#declare face_finish = finish {
    ambient 0.3
    specular 0.2
    diffuse 0.6
    roughness 0.1
    phong 0.6
    phong_size 20
}

#declare vertex_tex = texture {
    pigment { color vertex_color }
    finish { edge_finish }
}

#macro edge_tex(i)
    texture {
        pigment { edge_colors[i] }
        finish { edge_finish }
    }
#end

#macro face_tex(i)
    texture {
        pigment {
            color face_colors[i]
            filter face_filter
        }
        finish { face_finish }
    }
#end

#macro Vertex(p)
    sphere {
        p, vertex_size
        texture{ vertex_tex }
    }
#end

#macro Edge(i, p1, p2)
    cylinder {
        p1, p2, edge_size
        edge_tex(i)
    }
#end

#macro Face(i, num, pts)
    #local ind = 0;
    #local center = 0;
    #while (ind<num)
        #local center = center + pts[ind];
        #local ind=ind+1;
    #end
    #local center = center / num;

    union {
        polygon {
            num + 1,
            #local ind = 0;
            #while (ind<num)
                pts[ind]
                #local ind=ind+1;
            #end
            pts[0]
        }
        plane {
            vnormalize(center), vlength(center)
            clipped_by {
                #local ind = 0;
                #while (ind < num)
                    #local nv = vnormalize(vcross(pts[ind], pts[mod(ind+1, num)]));
                    #if (vdot(center - pts[ind], nv) > 0)
                        #local nv = -nv;
                    #end
                    plane {
                        nv, 0
                    }
                    #local ind = ind + 1;
                #end
            }
        }
        face_tex(i)
    }
#end

camera {
    location <0, 0, 1> * 3.2
    look_at <0, 0, 0>
    angle 40
    up y*image_height
    right x*image_width
}

light_source {
    <1, 1, 3> * 100
    color rgb 1
}

union {
    #include "polyhedra-data.inc"
}
