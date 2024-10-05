import wollok.game.*
import personaje.*
import posiciones.*
import pelea.*

/*Tenemos que hacerlo clase pero yo no entendí :)*/
object enemigo1 {
    var  position = game.at(14,12)
    const objetivoADestruir = personaje
    var property vida = 150
	
	method position() {
		return position
	}

    method image() { //image() se calcula a cada frame al igual que position(), si no entendí mal
		return "enemigo1" + self.estado() + "-32Bits.png"
	}

	method estado() {
		return ""
	}

    //MOVIMIENTO

    method distanciaEnEjeX() {
        return (objetivoADestruir.position().x() - position.x())
    }

    method distanciaEnEjeY() {
        return (objetivoADestruir.position().y() - position.y())
    }

    method mover() { 
        if (self.distanciaEnEjeX().abs() > self.distanciaEnEjeY().abs()) {
            if(self.distanciaEnEjeX() > 0) {
                position = derecha.siguiente(position)
            } else {
                position = izquierda.siguiente(position)
            }
        } else if (self.distanciaEnEjeY().abs() > self.distanciaEnEjeX().abs()) {
            if(self.distanciaEnEjeY() > 0) {
                position = arriba.siguiente(position)
            } else {
                position = abajo.siguiente(position)
            }
        }
    }

    // cuando el pj colsiona con el enemigo, este incia el combate
    method colisiono(personaje){
        self.combate()
    }

    // COMBATE/PELEA

    /*  - La posicion del enemigo es una celda a la derecha del personaje cuando empieza el combate.
        - Se le manda el enemigo a la barra de estado para saber con que enemigo esta peleando.
        - Aparece la barra de estado.
    */
    method combate() {
        
        combate.entidadAtacando(self)   //Hace saber al combate que él(enemigo/self) empieza
        combate.iniciarCombate()    //prepara toda el hud del combate y la info necesaria

        position = position.right(1)    //se posiciona una celda a la derecha del personaje
        game.say(self, "Ah! Pelea!")    // Avisa . Despues se va aquitar

        combate.cambiarTurnoA(self) //Empieza el combate
    }

    method atacarPre() {
        //game.schedule(300, { self.atacar(self)}) // para que quede más lindo a lo visual, que tarde un toque en atacar, que no sea instantaneo   
        self.atacar(self)
    }

    method atacar(_) { // el atributo  esta solo para el polimorfismo
        objetivoADestruir.recibirDanho(20) //FUTURO: Hacer las habilidades del enemigo y hacerlo clase
        combate.cambiarTurnoA(objetivoADestruir)
    }


    method recibirDanho(cantidad){
        vida = vida - cantidad
    }

    method morir() {
        /*Este método despues se va cambiar por un removeVisual o algo asi, esta así ahora para testear porque solo tenemos un enemigo.*/
        position = game.at(7,4)
        vida = 150
    }

}