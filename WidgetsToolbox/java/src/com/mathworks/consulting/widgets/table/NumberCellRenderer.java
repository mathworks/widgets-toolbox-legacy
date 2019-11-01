/*
 * Copyright (c) 2011-2018, The MathWorks, Inc.<consulting@mathworks.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

/* $Revision: 1.1.6.20 $ */

package com.mathworks.consulting.widgets.table;

import java.awt.Color;
import java.awt.Component;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import javax.swing.JLabel;
import javax.swing.JTable;
import javax.swing.table.DefaultTableCellRenderer;

/**
 * A subclass of DefaultTableCellRenderer for rendering numeric data, with a number format that can be configured at run time.
 */
public class NumberCellRenderer extends DefaultTableCellRenderer {
    
    DecimalFormat numberFormat;
    
    /**
     * Creates a NumberCellRenderer using the default pattern and symbols for the default locale.
     */
    public NumberCellRenderer() {
         numberFormat = new DecimalFormat();
    }
    
    /**
     * Creates a NumberCellRenderer using the given pattern and the symbols for the default locale.
     *
     * @param pattern a non-localized pattern string
     */
    public NumberCellRenderer( String pattern ) {
        numberFormat = new DecimalFormat( pattern );
    }
    
    /**
     * Creates a NumberCellRenderer using the given pattern and symbols.
     *
     * @param pattern a non-localized pattern string
     *
     * @param symbols the set of symbols to be used
     */
    public NumberCellRenderer( String pattern, DecimalFormatSymbols symbols ) {
        numberFormat = new DecimalFormat( pattern, symbols );
    }
    
    /**
     * Returns the component used for drawing the cell.
     *
     * @param jTable the JTable
     *
     * @param value the value to assign to the cell at [row, column]
     *
     * @param isSelected true if cell is selected
     *
     * @param hasFocus true if cell has focus
     * 
     * @param row the row of the cell to render
     *
     * @param column the column of the cell to render
     *
     * @return the component used for drawing the cell
     */
    @Override
    public Component getTableCellRendererComponent( JTable jTable, Object value, boolean isSelected, boolean hasFocus, int row, int column ) {
        Component c = super.getTableCellRendererComponent( jTable, value, isSelected, hasFocus, row, column );
        if ( c instanceof JLabel && value instanceof Number ) {
            JLabel label = (JLabel) c;
            label.setHorizontalAlignment( JLabel.RIGHT );
            Number num = (Number) value;
            String text = numberFormat.format( num );
            label.setText( text );
            label.setForeground( num.doubleValue() < 0 ? Color.RED : Color.BLACK );
        }
        return c;
    }
    
    /**
     * Gets the number format used by this cell renderer when formatting values.
     *
     * @return the number format
     */
    public DecimalFormat getNumberFormat() {
        return numberFormat;
    }
    
    /**
     * Sets the number format used by this cell renderer when formatting values.
     *
     * @param newNumberFormat the number format
     */
    public void setNumberFormat( DecimalFormat newNumberFormat ) {
        numberFormat = newNumberFormat;
    }
    
}
