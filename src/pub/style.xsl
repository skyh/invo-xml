<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html"/>
	<xsl:variable name="money-format" select="'####.00'"/>
	<xsl:variable name="hours-format" select="'#.00'"/>
	<xsl:template name="cur">
		<xsl:param name="v"/>
		<span class="cur"><span class="cur-sym">$</span><xsl:value-of select="format-number($v, $money-format)"/></span>
	</xsl:template>
	<xsl:template match="invoice">
		<html>
			<head>
				<title>
					Invoice <xsl:value-of select="@date"/>
				</title>
				<link rel="stylesheet" href="style.css"/>
			</head>
			<body>
				<h1>Invoice</h1>
				<div class="from">
					<xsl:apply-templates select="sides/from"/>
				</div>
				<div class="invoice-fields">
					<div class="to">
						Bill to:
						<xsl:apply-templates select="sides/to"/>
					</div>
					<table class="invoice-info">
						<tr>
							<th>Invoice No.</th>
							<td>
								<xsl:value-of select="@n"/>
							</td>
						</tr>
						<tr>
							<th>Date</th>
							<td>
								<xsl:value-of select="@date"/>
							</td>
						</tr>
						<tr>
							<th>Due Date</th>
							<td>
								<xsl:value-of select="@due-date"/>
							</td>
						</tr>
						<tr>
							<th>Contract</th>
							<td>
								<xsl:value-of select="@contract"/>
							</td>
						</tr>
					</table>
				</div>
				<xsl:apply-templates select="items"/>
				<xsl:apply-templates select="remarks"/>
				<xsl:apply-templates select="footer"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="side" match="from|to">
		<div class="org">
			<xsl:value-of select="."/>
		</div>
	</xsl:template>
	<xsl:template name="total">  
		<xsl:param name="nodes"/>
		<xsl:param name="sum" select="0"/>
		<xsl:variable name="curr" select="$nodes[1]" />
		<xsl:if test="$curr">
			<xsl:variable name="tsum" select="$sum + $curr/@q * $curr/@p"/>
			<xsl:call-template name="total">
				<xsl:with-param name="nodes" select="$nodes[position() &gt; 1]"/>
				<xsl:with-param name="sum" select="$tsum"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="not($curr)">
			<xsl:value-of select="$sum"/>
		</xsl:if>
	</xsl:template>	
	<xsl:template match="items">
		<table class="invoice-items">
			<xsl:if test="count(service) &gt; 0">
				<tbody>
					<tr>
						<th class="text">Item description</th>
						<th class="num">Price</th>
						<th class="num">Quantity</th>
						<th class="num">Amount</th>
					</tr>
					<xsl:apply-templates select="service"/>
				</tbody>
			</xsl:if>
			<xsl:if test="count(hours) &gt; 0">
				<tbody>
					<tr>
						<th class="text">Item description</th>
						<th class="num">Price</th>
						<th class="num">Hours</th>
						<th class="num">Amount</th>
					</tr>
					<xsl:apply-templates select="hours"/>
				</tbody>
			</xsl:if>
			<xsl:variable name="total">
				<xsl:call-template name="total">
					<xsl:with-param name="nodes" select="service|hours"/>
				</xsl:call-template>
			</xsl:variable>
        	<tfoot>
				<th colspan="3" class="total">Invoice total</th>
				<td class="num">
					<xsl:call-template name="cur">
						<xsl:with-param name="v" select="$total"/>
					</xsl:call-template>
				</td>
			</tfoot>
		</table>
	</xsl:template>
	<xsl:template match="service|hours">
		<xsl:variable name="qty-format">
			<xsl:choose>
				<xsl:when test="name() = 'service'">0</xsl:when>
				<xsl:when test="name() = 'hours'">#.00</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<tr class="invoice-item">
			<td class="text">
				<div class="text-title">
					<xsl:value-of select="@title"/>
				</div>
				<div class="text-subtitle">
					<xsl:value-of select="@subtitle"/>
				</div>
			</td>
			<td class="num">
				<xsl:call-template name="cur">
					<xsl:with-param name="v" select="@p"/>
				</xsl:call-template>
			</td>
			<td class="num">
				<xsl:value-of select="format-number(@q, $qty-format)"/>
			</td>
			<td class="num">
				<xsl:call-template name="cur">
					<xsl:with-param name="v" select="@p * @q"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="remarks">
		<h3>Remarks</h3>
		<div class="remarks">
			<xsl:value-of select="."/>
		</div>
	</xsl:template>
	<xsl:template match="footer">
		<div class="footer">
			<xsl:apply-templates select="col"/>
		</div>
	</xsl:template>
	<xsl:template match="footer/col">
		<div class="footer-col">
			<xsl:copy-of select="p"/>	
		</div>
	</xsl:template>
</xsl:stylesheet>
