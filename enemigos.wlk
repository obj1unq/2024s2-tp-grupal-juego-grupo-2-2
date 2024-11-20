import wollok.game.*
import personaje.*
import posiciones.*
import pelea.*
import extras.*
import mapa.*
import animaciones.*
import paleta.*

class Enemigo {
    const danhoBase 
    var position
    var salud
    const objetivoADestruir = personaje
    var acumuladorDeTurnos = 0
    const turnoRequeridoParaHabilidad

    method position() {
        return position
    }

    method salud() {
        return salud
    }

    //COMBATE

    method colisiono(personaje) {
        self.iniciarCombate() 
    }
    
    method iniciarCombate() { 

        position = position.left(2)    //se posiciona dos celdas a la izquierda del personaje
        combate.iniciarCombate(self)    //prepara el combate, la info necesaria y le hace saber que él(enemigo/self) será quien empieza

    }
      
    method atacarPre() {
      self.hacerTurno()
    }

    method hacerTurno() { 
        
        self.frame(0)
        self.animacion(animacionCombate)
        game.schedule(1600, {self.frame(0)})
        game.schedule(1605, {self.animacion(animacionEstatica)})
        game.schedule(1600, {self.realizarAtaqueNormalOHabilidad()}) //esto se encarga del ataque/habilidad y de sumar +1 a acumuladorDeTurnos
        game.schedule(1610, {combate.cambiarTurnoA(objetivoADestruir)})
        
    }
    
    method realizarAtaqueNormalOHabilidad() { 
        if(acumuladorDeTurnos < turnoRequeridoParaHabilidad) {
            acumuladorDeTurnos += 1
            objetivoADestruir.recibirDanho(danhoBase)
            barraEstadoPeleas.image("barraEnemigoAtaqueComun.png")
        } else {
            acumuladorDeTurnos = 0
            self.utilizarHabilidad()
        }
    }
    
    method recibirDanho(cantidad){
        salud = (salud - cantidad).max(0)
    }

    method morir() {
        self.frame(0)
        self.animacion(animacionMuerte)
        game.schedule(800, {game.removeVisual(self)})
        game.schedule(800, {dungeon.sacarEnemigo(self)})
    }

   
    //MOVIMIENTO

    method reaccionarAMovimiento() {
        
    } 

    method utilizarHabilidad()

    //ANIMACION
     
    var property animacion = animacionEstatica
    var property frame = 0

    method image()

    method maxFrameEstatica() {
        return 4
    }

    method maxFrameCombate() {
        return 8
    }

    method maxFrameMuerte() {
        return 4
    }

    method cambiarAnimacion() {
        animacion.cambiarAnimacion(self)
    }
      
}

class Jefe inherits Enemigo(turnoRequeridoParaHabilidad = 6) {


    var contadorMuertes = 0
    var fase = 0
    var estado = jefeFase1
    
    
    override method morir() {
        self.frame(0)
        self.animacion(animacionMuerte)
        game.schedule(500, {game.removeVisual(self)})

        game.schedule(1500, {self.cambiarFase()})


        //game.schedule(900, {self.muerte()})
    }


    method cambiarFase(){
        estado = jefeFase2
        estado.crearFase()

    }



    method muerte() {
        mapa.limpiar()
        gestorDeFondo.image("fondoVictoria.png")
        game.stop()
    }
 
    override method image() {
        return "jefe-" + animacion.tipo() + frame + "32Bits.png"
    } 

     
    override method utilizarHabilidad() { 

    }
    
    method text() = "JEFE >:l - Fase: " + estado.toString() + " "
    method textColor() = paleta.rojo()


}

object jefeFase1 {
    method crearFase() {
        const jefe1 = new Jefe(danhoBase = 5, position =  game.at(11,8),salud =  10)
        game.addVisual(jefe1)
    }
}
object jefeFase2 {
    method crearFase() {
        const jefe2 = new Jefe(danhoBase = 70, position =  game.at(11,8),salud =  150)
        game.addVisual(jefe2)

    }
}


class OjoVolador inherits Enemigo(turnoRequeridoParaHabilidad = 3) {

    //ANIMACION Y VISUAL
    
   override method image() { 
		return "ojoVolador-" + animacion.tipo() + frame + "32Bits.png"
	}

    override method maxFrameEstatica() {
        return 8
    }

    //MOVIMIENTO

    method distanciaEnEjeX() {
        return (objetivoADestruir.position().x() - position.x())
    }

    method distanciaEnEjeY() {
        return (objetivoADestruir.position().y() - position.y())
    }

    override method reaccionarAMovimiento() {
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
        salud += danhoBase * 2.5
        barraEstadoPeleas.image("barraEnemigoHabilidadSanacion.png")
    }

}

class Esqueleto inherits Enemigo(turnoRequeridoParaHabilidad = 4) {

    const vision

    //VISUAL Y ANIMACION

    override method image() {
        return "esqueleto-" + animacion.tipo() + frame + "32Bits.png" //En realidad es de 64x64
    }

    //MOVIMIENTO (en realidad, no se mueve, pero es lo que hace en vez de moverse)

    override method reaccionarAMovimiento() {

        self.revisarSiHayObjetivo()
    }

    method revisarSiHayObjetivo() {
        if(self.hayObjetivoEnVision() && self.position()!=objetivoADestruir.position()) { //esto para que no se choque con el self.combate() de colisiono()
            position = objetivoADestruir.position()
            self.iniciarCombate()
        }
    }

    method hayObjetivoEnVision() {
        return vision.hayObjetoEnX(self.position(), objetivoADestruir.position()) &&
               objetivoADestruir.position().y() == self.position().y()
    }

    // COMBATE/PELEA

    //el quinto ataque es habilidad

    override method utilizarHabilidad() {
        salud += danhoBase * 1.5
        objetivoADestruir.recibirDanho(danhoBase * 1.5)
        barraEstadoPeleas.image("barraEnemigoHabilidadRoboDeSalud.png")
    }

}

                /////////OBJETOS VISION DE ESQUELETO/////////////

object visionDerecha {

    method hayObjetoEnX(posObservador, posObservado) {
        return posObservado.x().between(posObservador.x(), posObservador.x()+3) //vision.hayObjetoEnX(self.position(), objetivoADestruir.position())
    }

}

object visionIzquierda {

    method hayObjetoEnX(posObservador, posObservado) {
        return posObservado.x().between(posObservador.x()-3, posObservador.x()) //vision.hayObjetoEnX(self.position(), objetivoADestruir.position())
    }

}

class Goblin inherits Enemigo(turnoRequeridoParaHabilidad = 2) {

    //VISUAL Y ANIMACION
       
    override method image() {
        return "goblin-" + animacion.tipo() + frame +  "32Bits.png" 
    }

    // COMBATE/PELEA

    //el tercer ataque es habilidad

    override method utilizarHabilidad() {
        objetivoADestruir.recibirDanho(danhoBase * 3)
        barraEstadoPeleas.image("barraEnemigoHabilidadGolpeMortal.png")
    }

}

object fabricaDeOjoVolador {

    method agregarNuevoEnemigo(_position, _salud, _danhoBase) {
        const ojo = new OjoVolador(position = _position, salud = _salud, danhoBase = _danhoBase)
        dungeon.registrarEnemigo(ojo)
        game.addVisual(ojo)
  }
  
}

object fabricaDeEsqueleto {

    method agregarNuevoEnemigo(_position, _salud, _danhoBase, _vision) {
        const esqueleto = new Esqueleto(position = _position, salud = _salud, danhoBase = _danhoBase, vision = _vision)
        dungeon.registrarEnemigo(esqueleto)
        game.addVisual(esqueleto)
  }

}

object fabricaDeGoblin {

    method agregarNuevoEnemigoCon(_position, _salud, _danhoBase) {
        const goblin = new Goblin(position = _position, salud = _salud, danhoBase = _danhoBase)
        dungeon.registrarEnemigo(goblin)
        game.addVisual(goblin)
    }

}
