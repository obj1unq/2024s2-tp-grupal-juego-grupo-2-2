import personaje.*

class Estado {

    method puedeHacerTurno() {
        return false //el original devuelve false porque solo para un wko queremos que de true. se hace el override solo en ese caso.
    }

}


object estatico inherits Estado {

    override method puedeHacerTurno() {
        return true
    }

}

object muriendo inherits Estado { }

class EstadoHaceTurno inherits Estado {

    method realizarAccionCorrespondiente()

}

object golpeando inherits EstadoHaceTurno { 

    override method realizarAccionCorrespondiente() {
        personaje.realizarAtaqueComun()
    }

}

object haciendoHabilidad inherits EstadoHaceTurno { 

    override method realizarAccionCorrespondiente() {
        personaje.realizarHabilidadEspecial()
    }

}

object curandose inherits EstadoHaceTurno { 

    override method realizarAccionCorrespondiente() {
        personaje.usarPocionSalud()
    }

}