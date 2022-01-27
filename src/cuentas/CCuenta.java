package cuentas;

/**
 * Esta clase CCuenta la utilizamos para operar con el objeto CCuenta. Contiene todos los métodos necesarios
 * @author Javier Pego Paz
 * @version 2.0
 * @since 1.0
 * 
 */
public class CCuenta {

    private String nombre;
    private String cuenta;
    private double saldo;
    private double tipoInterés;
    
    /**
     * Este es el método get del atributo privado nombre
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * Este es el método set del atributo privado nombre
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    /**
     * Este es el método get del atributo privado cuenta
     * @return the cuenta
     */
    public String getCuenta() {
        return cuenta;
    }

    /**
     * Este es el método set del atributo privadocuenta
     * @param cuenta the cuenta to set
     */
    public void setCuenta(String cuenta) {
        this.cuenta = cuenta;
    }

    /**
     * Este es el método get del atributo privado saldo
     * @return the saldo
     */
    public double getSaldo() {
        return saldo;
    }

    /** 
     * Este es el método set del atributo privado saldo
     * @param saldo the saldo to set
     */
    public void setSaldo(double saldo) {
        this.saldo = saldo;
    }

    /**
     * Este es el método get del atributo privado tipo de interés
     * @return the tipoInterés
     */
    public double getTipoInterés() {
        return tipoInterés;
    }

    /**
     * Este es el método set del atributo privado tipoInterés
     * @param tipoInterés the tipoInterés to set
     */
    public void setTipoInterés(double tipoInterés) {
        this.tipoInterés = tipoInterés;
    }

    /**
     * Este es el método constructor del objeto cuenta. Se le pasan los siguientes parámetros:
     * @param nom el nombre del dueño de la cuenta
     * @param cue la cuenta completa del banco
     * @param sal el saldo en cuenta
     * @param tipo el tipo de cuenta
     */
    public CCuenta(String nom, String cue, double sal, double tipo)
    {
        nombre =nom;
        cuenta=cue;
        saldo=sal;
    }
    /**
     * Este método nos devuelve la cantidad de saldo en cuenta
     * @return Devuelve la cantidad de saldo 
     */
    public double estado()
    {
        return getSaldo();
    }

    /**
     * Este método ingresa una cantidad en la cuenta
     * @param cantidad es el monto a ingresar
     * @throws Exception Si se intenta ingresar una cantidad negativa devuelve el error. "No se puede ingresar una cantidad negativa"
     */
    public void ingresar(double cantidad) throws Exception
    {
        if (cantidad<0)
            throw new Exception("No se puede ingresar una cantidad negativa");
        setSaldo(getSaldo() + cantidad);
    }
    /**
     * Este método retira saldo de la cuenta
     * @param cantidad la cantidad a retirar (double)
     * @throws Exception  Si no hay suficiente saldo devuelve el error "no hay suficiente saldo"
     */
    public void retirar(double cantidad) throws Exception
    {
        if (cantidad <= 0)
            throw new Exception ("No se puede retirar una cantidad negativa");
        if (estado()< cantidad)
            throw new Exception ("No se hay suficiente saldo");
        setSaldo(getSaldo() - cantidad);
    }
}
