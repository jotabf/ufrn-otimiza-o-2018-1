MIN = -500;
MAX = 500;

best = 10e9;

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


//Funçoes de inicializaçao//
function cromo = criar_cromo( tamCrom )
    for i = 1:tamCrom
        cromo(1,i) = round(rand());
    end
endfunction

function pop = criar_pop( tamPop , tamCrom )
    for i = 1:tamPop
        pop(i,:) = criar_cromo( tamCrom )
    end
endfunction

//Etapa 01// 
function [x,y] = bits_dec( cromo )
    x = 0;
    y = 0;
    tam = length( cromo )/2;      
    for i = 1:tam
        x = x + cromo(i)*2^(tam - i);
        y = y + cromo(i + tam)*2^(tam - i);
    end 
    x = MIN + (MAX - MIN)*x/(2^tam-1);
    y = MIN + (MAX - MIN)*y/(2^tam-1);
endfunction

function apt = avaliar( pop )
    tamPop = size(pop,1)
    for i = 1:tamPop
        [a,b] = bits_dec( pop(i,:) );
        apt(i) = func(a,b);
    end
endfunction

function roleta = criarRoleta(apt)
    apt_n = apt - min(apt) + 1;
    prob = 0;
    for i = 1:length(apt)
        prob = prob + apt_n(i)/sum(apt_n);
        roleta(i) = prob;
        disp(prob);
    end
endfunction

function selecionados = selecaoNatural(probRoleta)
    tamPop = length(probRoleta);
    for i = 1:tamPop
        agulha = rand();
        for j = 1:tamPop
            if (agulha <= probRoleta(j))
                selecionados(i) = j;
                break;
            end
        end
    end
endfunction


function novaPop = crossover( pop, probCross )
    [tamPop tamCromo] = size( pop );
    
    for i = 1:2:(tamPop-1)
        prob = rand();
        pai = pop(i,:);
        mae = pop(i+1,:);
        
        if (prob <= probCross ) then
            pc = round(rand()*(tamCromo-2)) + 1; //Ponto de Corte
            
            filho1 = [pai(1:pc) mae((pc+1):tamCromo)];
            filho2 = [mae(1:pc) pai((pc+1):tamCromo)];
            
            novaPop(i,:) = filho1;
            novaPop(i+1,:) = filho2;            
        else
            novaPop(i,:) = pai;
            novaPop(i+1,:) = mae;
        end    
    end
endfunction

function novaPop = mutacao( pop, probMut )
    [tamPop tamCromo] = size( pop );
    
    for i = 1:tamPop
        for j = 1:tamCromo
            prob = rand();
            if (prob <= probMut) then
                bit = pop(i,j);
                pop(i,j) = 1 - bit;
            end
        end
    end
    novaPop = pop;   
endfunction

function drawFitnessFunction()    
    [x,y] = meshgrid(MIN:5:MAX);    
    z = func(x,y);
    surf(x,y,z,'colorda',ones(10,10),'edgecol','cya');
endfunction

function solucao = algGenetico(tamPop, tamCrom, probCross, probMut, qtMaxGeracoes)
    
    pop = criar_pop(tamCrom);
       
    for i = 1:qtMaxGeracoes
      
      apt = avaliar(pop);
      prob = criarRoleta(apt);
      popSel = selecaoNatural(prob);
            
//      novaPop = crossover(popSel, probCross);
//      novaPop = mutacao(novaPop, probMut);      
//      
      pop = popSel;
    end
    
    for i = 1:tamPop
        [a,b] = bits_dec(pop(i,:));
        pontos(i,:) = [a,b]
        solucao(i) = func(a,b);
    end
    disp(pontos);
    disp(solucao);  
        
endfunction

solucao = algGenetico(10, 20, 0.7, 0.1, 1);





