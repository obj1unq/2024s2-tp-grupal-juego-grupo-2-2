import wollok.game.*
import personaje.*
import posiciones.*
import pelea.*
import extras.*

//PREGUNTAR sobre como hacer un objeto que herencie una clase que está
//dentro de una superclase --> esqueleto

class Enemigo {
    const danhoBase 
    var position
    var vida
    const objetivoADestruir = personaje
    var acumuladorDeTurnos = 0
    const turnoRequeridoParaHabilidad

    method position() {
        return position
    }

    method vida() {
        return vida
    }

    method colisiono(personaje) {
        self.combate() 
    }
    
    method combate() {
        combate.entidadAtacando(self)   //Hace saber al combate que él(enemigo/self) será quien empieza
        combate.iniciarCombate()    //prepara toda el hud del combate y la info necesaria

        position = position.right(1)    //se posiciona una celda a la derecha del personaje
        game.say(self, "Ah! Pelea!")    // Avisa . Despues se va a quitar

        combate.cambiarTurnoA(self) //Empieza el combate
    }
      
    method atacarPre() {
      self.atacar()
    }

    //capaz se podría llamar hacerTurno(), porque algunas subclases de enemigo tienen habilidades curativas!
    method atacar() { 
        self.realizarAtaqueNormalOHabilidad() //esto se encarga del ataque/habilidad y de sumar +1 a acumuladorDeTurnos
        combate.cambiarTurnoA(objetivoADestruir)
    }
    
    method recibirDanho(cantidad){
        vida = vida - cantidad
    }

    method morir() {
        game.removeVisual(self)
        dungeon.enemigos().remove(self)
    }

    method realizarAtaqueNormalOHabilidad() { 
        if(acumuladorDeTurnos < turnoRequeridoParaHabilidad) {
            acumuladorDeTurnos += 1
            objetivoADestruir.recibirDanho(danhoBase)
        } else {
            acumuladorDeTurnos = 0
            self.utilizarHabilidad()
        }
    }

    method image() 
    method estado() 
    method reaccionarAMovimiento() 
    //method danhoAtaque()
    //method habilidad()
    method utilizarHabilidad()
      
}

class OjoVolador inherits Enemigo(turnoRequeridoParaHabilidad = 3) {
    
   override  method image() { 
		return "ojoVolador" + self.estado().imagenParaPersonaje() + "-32Bits.png"
	}

	override method estado() {
		return ojoSinArma //como, de momento, tiene un solo estado, es un poco raro. Tendrá mas sentido si tiene más estados (como el pj)
	}

    //MOVIMIENTO

    method distanciaEnEjeX() {
        return (objetivoADestruir.position().x() - position.x())
    }

    method distanciaEnEjeY() {
        return (objetivoADestruir.position().y() - position.y())
    }

    override method reaccionarAMovimiento() {   // SI HAY MAS DE UN ENEMIGO QUE NO SE METAN LOS DOS EN LA MISMA CELDA
        if (self.distanciaEnEjeX().abs() > self.distanciaEnEjeY().abs()) {
            if(self.distanciaEnEjeX() > 0) {
                const posicionSiguiente = derecha.siguiente(position)
                self.moverseSiNoHayOtroA(posicionSiguiente)
            } else {
                const posicionSiguiente = izquierda.siguiente(position)
                self.moverseSiNoHayOtroA(posicionSiguiente)
            }
        } else if (self.distanciaEnEjeY().abs() > self.distanciaEnEjeX().abs()) {
            if(self.distanciaEnEjeY() > 0) {
                const posicionSiguiente = arriba.siguiente(position)
                self.moverseSiNoHayOtroA(posicionSiguiente)
            } else {
                const posicionSiguiente = abajo.siguiente(position)
                self.moverseSiNoHayOtroA(posicionSiguiente)
            }
        }
    }

    method moverseSiNoHayOtroA(posicionSiguiente) { //El ojo se mueve si no hay otro enemigo en la celda. Así se evitan choques entre ellos.
        if(!dungeon.hayEnemigoEn(posicionSiguiente)) {
            position = posicionSiguiente
        }
    }

    // COMBATE/PELEA

    //el cuarto ataque es habilidad

    override method utilizarHabilidad() {
        game.say(self, "¡Uso habilidad Poción de Vida!")
        vida += danhoBase * 3
    }

}

class Esqueleto inherits Enemigo(turnoRequeridoParaHabilidad = 4) {
   // const vision

    override method image() {
        return "esqueleto" + self.estado().imagenParaPersonaje() + "-32Bits.png" //EMOSIDO ENGAÑADO. ES DE 64X64!!
    }

    override method estado() {
        return esqueletoSinArma
    }

    //MOVIMIENTO (en realidad, no se mueve, pero es lo que hace en vez de moverse)

    override method reaccionarAMovimiento() {

        self.revisarSiHayObjetivo()
    }

    //se tuvo que remplazar la validación por directamente un if. Si se cumple condición, se dispara combate.
    //la validación causaba que, si personaje no estaba en el rango de visión del esqueleto, tirara ERROR, y eso causaba que se deje de

    //ejecutar el método de dungeon accionEnemigos() que hace que todos los enemigos de la dungeon ejecuten reaccionarAMovimiento(),

    //por lo que todos los enemigos que venían después del 1er esqueleto en la lista de enemigos de la dungeon NO SE MOVÍAN (ya que
    //el error paraba la ejecución del método accionEnemigos)
    //con el if no pasa eso. Si no está en el rango de visión del esqueleto, no hace nada y listo. NO se tira un error.
    //entiendo que, conceptualmente, no está mal, ya que el método no promete atacar, sino que promete REVISAR (y, si dps de revisar,
    //ve al personaje cerca, ahí sí ataca)
    method revisarSiHayObjetivo() {
        //self.validarEncontrar() ESTO CAUSABA BUG AL TENER 2 ESQUELETOS. No queda otra más que sacarlo
        if(self.hayObjetivoEnVision() && self.position()!=objetivoADestruir.position()) { //esto para que no se choque con el self.combate() de colisiono()
            position = objetivoADestruir.position()
            self.combate()
        }
    }

    //method validarEncontrar() {
    //    if (!self.hayObjetivoEnVision()) {
    //        self.error("")
    //    }
    //}

    method hayObjetivoEnVision() {
        return area.hayObjetivo(self.position(), objetivoADestruir.position()) 
              // objetivoADestruir.position().y() == self.position().y()
    }

    // COMBATE/PELEA

    //el quinto ataque es habilidad

    override method utilizarHabilidad() {
        game.say(self, "¡Uso habilidad Robo de Energia!")
        vida += danhoBase * 1.5
        objetivoADestruir.recibirDanho(danhoBase * 1.5)
    }

}

/////////objetos visión/////////////

object area {
    method hayObjetivo(posEnemigo, posPJ){
        return lineaCeldas.hayObjeto(posEnemigo, posPJ) ||
               lineaCeldas.hayObjeto(posEnemigo.up(1), posPJ) ||
               lineaCeldas.hayObjeto(posEnemigo.down(1), posPJ)

    }

}




object lineaCeldas {

    method hayObjeto(posObservador, posObservado) {
        return posObservado.x().between(posObservador.x()-2, posObservador.x()+2) and
                posObservado.y().between(posObservador.y()-2, posObservador.y()+2) //vision.hayObjetoEnX(self.position(), objetivoADestruir.position())
    }

}


class Goblin inherits Enemigo(turnoRequeridoParaHabilidad = 2) {
       
    override method image() {
        return "enemigo1" + self.estado().imagenParaPersonaje() + "-32Bits.png" //momentáneamente, la imagen es la de Silvestre
    }

    override method estado() {
        return goblinSinArma
    }

    //MOVIMIENTO (en realidad, no se mueve)

    override method reaccionarAMovimiento() { }

    // COMBATE/PELEA

    //el tercer ataque es habilidad

    override method utilizarHabilidad() {
        game.say(self, "¡Uso habilidad Golpe Mortal!")
        objetivoADestruir.recibirDanho(danhoBase * 3)
    }

}

//FACTORIES DE ENEMIGOS
//Tener en cuenta que, de momento, el método que tienen es para crear un enemigo en base a parámetros y no con atributos random.
//para randomizar, si quisiéramos hacerlo, lo haríamos como hicimos en las factories de armas

object fabricaDeOjoVolador {

    method agregarNuevoEnemigo(_position, _vida, _danhoBase) {
        const ojo = new OjoVolador(position = _position, vida = _vida, danhoBase = _danhoBase)
        dungeon.registrarEnemigo(ojo)
        game.addVisual(ojo)
  }
  
}

object fabricaDeEsqueleto {

    method agregarNuevoEnemigo(_position, _vida, _danhoBase) {
        const esqueleto = new Esqueleto(position = _position, vida = _vida, danhoBase = _danhoBase)
        dungeon.registrarEnemigo(esqueleto)
        game.addVisual(esqueleto)
  }

}

object fabricaDeGoblin {

    method agregarNuevoEnemigoCon(_position, _vida, _danhoBase) {
        const goblin = new Goblin(position = _position, vida = _vida, danhoBase = _danhoBase)
        dungeon.registrarEnemigo(goblin)
        game.addVisual(goblin)
    }

}

//estados de las distintas clases de enemigos 
//(¿van a tener algo más que solo la imagen? porque, sino, leo dijo que no está tan bueno hacer objetos de estado así. Podríamos no tener
//estado y en el método image() simplemente hacer un if, según dijo)


object ojoSinArma {

    method imagenParaPersonaje() {
        return ""
    }

}

object esqueletoSinArma {

    method imagenParaPersonaje() {
      return ""
    }

}

object goblinSinArma {

    method imagenParaPersonaje() {
        return ""
    }

}

