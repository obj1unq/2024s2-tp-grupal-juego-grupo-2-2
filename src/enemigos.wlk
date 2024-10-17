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

    method atacar() {
        objetivoADestruir.recibirDanho(self.danhoAtaque()) //FUTURO: Hacer las habilidades del enemigo y hacerlo clase
        acumuladorDeTurnos+=1
        combate.cambiarTurnoA(objetivoADestruir)
    }
    
    method recibirDanho(cantidad){
        vida = vida - cantidad
    }

    method morir() {
        game.removeVisual(self)
    }

    method image() 
    method estado() 
    method mover() 
    method danhoAtaque()
    method habilidad()
      
}

class OjoVolador inherits Enemigo {
    
   override  method image() { //image() se calcula a cada frame al igual que position(), si no entendí mal
		return "ojito32a.png"
        
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

   override method mover() { 
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

    // COMBATE/PELEA
    
    override method danhoAtaque() {
        if(acumuladorDeTurnos < 3) { //el cuarto ataque es habilidad
            return danhoBase //20
        } else {
            acumuladorDeTurnos = -1
            return self.habilidad()
        }
    }

    override method habilidad() {
        return danhoBase * 4 //combate.cambiarTurnoA(self) (saltea al rival y ataca otra vez)
    }

}

class Esqueleto inherits Enemigo {

    override method image() {
        return "esqueleto" + self.estado().imagenParaPersonaje() + "-32Bits.png"
    }

    override method estado() {
        return esqueletoSinArma
    }

    override method mover() {
           self.encontrarObjetivo()
    }

    method encontrarObjetivo() {
        self.validarEncontrar()
        position = objetivoADestruir.position()
        self.combate()
    }

    method validarEncontrar() {
        if (!self.hayObjetivoEnVision()) {
            self.error("")
        }
    }

    method hayObjetivoEnVision() {
        return objetivoADestruir.position().x().between(3, 7) && objetivoADestruir.position().y() == self.position().y()
    }
    override method danhoAtaque() { //el quinto ataque es habilidad
        if(acumuladorDeTurnos < 4) {
          return danhoBase //43
        } else {
            acumuladorDeTurnos = -1
            return self.habilidad()
        }
    }

    override method habilidad() {
        return danhoBase * 2 
    }

}

class Goblin inherits Enemigo {
       
    override method image() {
        return "enemigo1" + self.estado().imagenParaPersonaje() + "-32Bits.png"
    }

    override method estado() {
        return goblinSinArma
    }

    override method mover() { }

    override method danhoAtaque() { //el tercer ataque es habilidad
        if(acumuladorDeTurnos < 2) {
          return danhoBase //37
        } else {
            acumuladorDeTurnos = -1
            return self.habilidad()
        }
    }

    override method habilidad() {
        return danhoBase * 3
    }

}

//FACTORIES DE ENEMIGOS
//Tener en cuenta que, de momento, el método que tienen es para crear un enemigo en base a parámetros y no con atributos random.
//para randomizar, si quisiéramos hacerlo, lo haríamos como hicimos en las factories de armas

object fabricaDeOjoVolador {

    method agregarNuevoEnemigo(_position, _vida, _danhoBase) {
        const ojo = new OjoVolador(position = _position, vida = _vida, danhoBase = _danhoBase)
        dungeon.enemigos().add(ojo)
        game.addVisual(ojo)
  }
  
}

object fabricaDeEsqueleto {

    method agregarNuevoEnemigo(_position, _vida, _danhoBase) {
        const esqueleto = new Esqueleto(position = _position, vida = _vida, danhoBase = _danhoBase)
        dungeon.enemigos().add(esqueleto)
        game.addVisual(esqueleto)
  }

}

object fabricaDeGoblin {

    method agregarNuevoEnemigoCon(_position, _vida, _danhoBase) {
        const goblin = new Goblin(position = _position, vida = _vida, danhoBase = _danhoBase)
        dungeon.enemigos().add(goblin)
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

