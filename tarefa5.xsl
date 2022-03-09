<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8"/>
<xsl:template match="/artistas">
<html>
    <head>
      <title>Listado de Artistas - Javier Pego Paz</title>
    </head>
    <body>
      <table>
        <tr>
          <th>Código</th>
          <th>Nombre</th>
          <th>Año de nacimiento</th>
          <th>Año de fallecimiento</th>
          <th>País</th>
          <th>Página web</th>
        </tr>
        <xsl:apply-templates select="./artista">
        <xsl:sort select="nacimiento"> 
        </xsl:sort>
        </xsl:apply-templates>
      </table>
    </body>
  </html>
  </xsl:template>
  <xsl:template match="//artista">
    <xsl:if test="./nacimiento>'1500'">
      <tr>
        <td><xsl:value-of select="@cod"/></td>
        <td><xsl:value-of select="nombreCompleto"/></td>
        <td><xsl:value-of select="nacimiento"/></td>
        <xsl:if test="not(./fallecimiento)"><td>Desconocido</td></xsl:if>
        <xsl:if test="(./fallecimiento)"><td><xsl:value-of select="fallecimiento"/></td></xsl:if>
        <td><xsl:value-of select="pais"/></td>
        <td><a target="blank" href="{fichaCompleta}">Saber más</a></td>
      </tr>
    </xsl:if>
</xsl:template>
</xsl:stylesheet>