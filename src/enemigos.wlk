import wollok.game.*
import personaje.*
import posiciones.*
import pelea.*
import extras.*
import mapa.*
import animaciones.*

class Enemigo {
    const danhoBase 
    var property position
    var salud
    const objetivoADestruir = personaje
    var acumuladorDeTurnos = 0
    const turnoRequeridoParaHabilidad
    var turnosEnvenenado = 0
    const danhoPorVeneno = 20
    var property turnosAturdido = 0
    const property esEnemigo = true

    method acumuladorDeTurnos(_acumuladorDeTurnos) { //Setter solo para testear
        acumuladorDeTurnos = _acumuladorDeTurnos
    }

    method turnosEnvenenado(_turnosEnvenenado) {
        turnosEnvenenado = _turnosEnvenenado
    }

    method salud() {
        return salud
    }

    //COMBATE

    method colisiono(personaje) {
        self.iniciarCombate() 
    }
    
    method iniciarCombate() { 
        position = self.nuevaPosicionParaCombate() //se posiciona a la izquierda del personaje SI ES POSIBLE (debe estar dentro de los bordes y no debe haber otra cosa en la celda)
        combate.iniciarCombate(self) //prepara el combate, la info necesaria y le hace saber a este que él(enemigo/self) será quien empieza
    }
    
    method nuevaPosicionParaCombate() { //en base a distanciaAlPersonaje(), se buca la pos a la izq del personaje más cercana a ese valor
        const posibles = (self.distanciaAlPersonaje()..1) //queremos encontrar la más cercana a la ideal
        const val = posibles.findOrElse({v => (!dungeon.hayAlgoEn(position.left(v)) && dungeon.estaDentro(position.left(v)))}, { 0 })
        return position.left(val)
    }

    method distanciaAlPersonaje() {
        return 2
    }
      
    method atacarPre() {
      self.hacerTurno()
    }

    method hacerTurno() { //1ro sufriría el daño del veneno antes de poder atacar, si corresponde. asi que, si es mortal, se muere sin atacar.

        if(self.estaEnvenenado() && salud <= danhoPorVeneno) {
            self.recibirDanho(danhoPorVeneno)
            self.morir()
        } else { 
            self.frame(0)
            self.animacion(animacionCombate)
            game.schedule(1600, {self.terminarHacerTurno()}) //dentro de 1,6 seg para que se pueda ver la animación primero
        }
        
    }

    method terminarHacerTurno() {
        self.sufrirVenenoSiCorresponde() //este es el caso donde, si hay daño por veneno, NO va a ser mortal
        self.realizarAtaqueNormalOHabilidad() //esto se encarga del ataque/habilidad y de sumar +1 a acumuladorDeTurnos
        self.frame(0)
        self.animacion(animacionEstatica)
        combate.cambiarTurnoA(objetivoADestruir)
    }
    
    method realizarAtaqueNormalOHabilidad() { 
        if(acumuladorDeTurnos < turnoRequeridoParaHabilidad) { // habilidad basica
            acumuladorDeTurnos += 1
            self.utilizarAtaqueNormal()
        } else {    //habilidad especial
            acumuladorDeTurnos = 0  
            self.utilizarHabilidad()
        }
    }

    method utilizarAtaqueNormal() {
        objetivoADestruir.recibirDanho(danhoBase)
        self.sonidoAtaque()
        barraEstadoPeleas.image("barraEnemigoAtaqueComun.png")
    }

    method sufrirVenenoSiCorresponde() { //este es el caso donde, si hay daño por veneno, NO va a ser mortal
        if(self.estaEnvenenado()) {
            self.recibirDanho(danhoPorVeneno)
            turnosEnvenenado -= 1
        }
    }

    method sufrirAturdimiento() {
		turnosAturdido -= 1
	}
    
    method recibirDanho(cantidad){
        salud = (salud - cantidad).max(0)
    }

    method morir() {
        personaje.sumarEnemigoAsesinado() // para pasar de nivel
        
        dungeon.abrirPuertaSiSePuede()

        self.frame(0)
        self.animacion(animacionMuerte)
        game.schedule(800, {self.terminarMorir()}) //dentro de 0,8 seg para que se pueda ver la animación primero
    }

    method terminarMorir() {
        game.removeVisual(self)
        dungeon.sacarEnemigo(self)
        combate.hayCombate(false)
		barraEstadoPeleas.desaparecerJuntoADemasBarras()
    }

    method estaEnvenenado() {
        return turnosEnvenenado > 0
    }

    method estaAturdido() {
		return turnosAturdido > 0
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
    
    method sonidoAtaque() 
}

/////////////  JEFE FINAL ///////////////////////////

class Jefe inherits Enemigo(turnoRequeridoParaHabilidad = 6) {// Turno requerido 6 porque tiene habilidades fuertes y 
                                                              // queremos generar la necesidad de matarlo antes que esta 

    var fase 

    method fase(_fase) {
        fase = _fase
    }

    override method image() {
        return  "jefe" + fase + animacion.tipo() + frame + "32Bits.png"
    }

}

//FASES DEL JEFE 


object jefeFase1 inherits Jefe(danhoBase = 40, position = game.at(11, 8), salud = 300, fase = 1 ) {

    override method utilizarHabilidad() { //bola de energia
        objetivoADestruir.recibirDanho(150)
        barraEstadoPeleas.image("barraJefe1Habilidad.png")
    }

    override method morir() {
        super()
        game.schedule(1000, {self.cambiarFase()})        
    }
    
    method cambiarFase() {
       // self.fase(jefeFase2)
        game.addVisual(jefeFase2)
        dungeon.registrarEnemigo(jefeFase2)
    }

    override method distanciaAlPersonaje() {
        return 3
    }

    override method sonidoAtaque() { // por ahora ninugno
      
    }
}

object jefeFase2 inherits Jefe(danhoBase = 80, position = game.at(11, 8), salud = 450, fase = 2 ) {

    override method utilizarHabilidad() { //Acá quiero que el personaje pierda dos turnos
        objetivoADestruir.recibirDanho(danhoBase)
        objetivoADestruir.turnosAturdido(2)
        barraEstadoPeleas.image("barraJefe2Habilidad.png")
    }

    override method maxFrameCombate() {
        return 4
    }

    override method distanciaAlPersonaje() {
        return 6
    }

    override method sonidoAtaque() { // por ahora ninugno
      
    }
}

/////////////  OJO VOLADOR ///////////////////////////

class OjoVolador inherits Enemigo(turnoRequeridoParaHabilidad = 5) {

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
        if(!dungeon.hayAlgoEn(posicionSiguiente)) {
            position = posicionSiguiente
        }
    }

    // COMBATE/PELEA

    //el cuarto ataque es habilidad

    override method utilizarHabilidad() {
        salud += danhoBase * 2.5
        barraEstadoPeleas.image("barraEnemigoHabilidadSanacion.png")
        game.sound("sanacion.mp3").play()
    }

    override method sonidoAtaque() {
      
    }
}

/////////////  ESQUELETO ///////////////////////////

class Esqueleto inherits Enemigo(turnoRequeridoParaHabilidad = 4) {

    const rangoVision = 3

    //VISUAL Y ANIMACION

    override method image() {
        return "esqueleto-" + animacion.tipo() + frame + "32Bits.png" //En realidad es de 64x64
    }

    //MOVIMIENTO (en realidad, no se mueve, pero es lo que hace en vez de moverse)

    override method reaccionarAMovimiento() {

        self.revisarSiHayObjetivo()

    }

    method revisarSiHayObjetivo() {
        if(self.hayObjetoEnVision() && self.position()!=objetivoADestruir.position()) { //esto para que no se choque con el self.combate() de colisiono()
            position = objetivoADestruir.position()
            self.iniciarCombate()
        }
    }

    method hayObjetoEnVision() {
        return objetivoADestruir.position().x().between((self.position().x()-rangoVision), (self.position().x()+rangoVision)) &&
               objetivoADestruir.position().y().between((self.position().y()-rangoVision), (self.position().y()+rangoVision))
    }

    // COMBATE/PELEA

    //el quinto ataque es habilidad

    override method utilizarHabilidad() {
        salud += danhoBase * 1.5
        objetivoADestruir.recibirDanho(danhoBase * 1.5)
        barraEstadoPeleas.image("barraEnemigoHabilidadRoboDeSalud.png")
        game.sound("sanacion.mp3").play()
    }

    override method sonidoAtaque() {
      game.sound("espadaEnemigo.mp3").play()
    }
}

/////////////  GOBLIN ///////////////////////////

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

    override method sonidoAtaque() {
      game.sound("cuchilloEnemigo.mp3").play()
    }

}

/////////////  FACTORIES DE ENEMIGOS ////////////

object fabricaDeOjoVolador {

    method agregarNuevoEnemigo(_position, _salud, _danhoBase) {
        const ojo = new OjoVolador(position = _position, salud = _salud, danhoBase = _danhoBase)
        dungeon.registrarEnemigo(ojo)
        game.addVisual(ojo)
  }
  
}

object fabricaDeEsqueleto {

    method agregarNuevoEnemigo(_position, _salud, _danhoBase, _rangoVision) {
        const esqueleto = new Esqueleto(position = _position, salud = _salud, danhoBase = _danhoBase, rangoVision = _rangoVision)
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
