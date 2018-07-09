MIN = -500;
MAX = 500;

function res = func(x,y)
    z = - x.*sin( sqrt( abs(x) ) ) - y.*sin( sqrt( abs(y) ) );      
    
    x = x/250;
    y = y/250;
       
    r = 100*( y - x.^2 ).^2 + ( 1 - x ).^2;
    r1 = ( y - x.^2 ).^2 + ( 1 - x ).^2;        
    
    w = r.*z;    
    w2 = z - r1;    
    w6 = w + w2;
    res = w6;
endfunction

function best = pso( tamEnxame , vmax, w, c1, c2, nIter )
    
    rand('seed',getdate('s'));
    x = rand(2,tamEnxame,"uniform")*(MAX - MIN) + MIN;
    v = rand(2,tamEnxame,"uniform")*vmax;

    p = x;
    g = p(:,1);
  
    for k = 1:nIter
        for i = 1:tamEnxame
            if func(x(1,i),x(2,i)) < func(p(1,i),p(2,i))
                p(:,i) = x(:,i);
                if func(x(1,i),x(2,i)) < func(g(1,1),g(2,1))
                   g = x(:,i);
                end
            end

            for j = 1:2
                r1 = rand();
                r2 = rand(); 
             
                v(j,i) = w*v(j,i) + c1*r1*(p(j,i) - x(j,i)) + c2*r2*(g(j) - x(j,i)); 
            end                
            
            x_ = x(:,i) + v(:,i);
            
            x_( x_ > MAX ) = MAX;
            x_( x_ < MIN ) = MIN;
            
            x(:,i) = x_;
        end 
               
    end
    
    best = g;
endfunction

w = 0.5
c1 = 1.5  //1,5 2,5
c2 =  1.5 //1,5 2,5
vmax = 10;
nIter = 100;
tamExame = 20;

res = pso( tamExame, vmax, w, c1, c2, nIter );

disp(func(res(1), res(2)));



