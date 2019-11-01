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

import java.awt.Component;
import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.text.DateFormatSymbols;
import javax.swing.JLabel;
import javax.swing.JTable;
import javax.swing.table.DefaultTableCellRenderer;

/**
 * Renderer for date cells, with configurable format
 */
public class DateCellRenderer extends DefaultTableCellRenderer {

    SimpleDateFormat dateFormat;

    /**
     * Constructors
     */
    public DateCellRenderer() {
        dateFormat = new SimpleDateFormat();
    }

    public DateCellRenderer(String pattern) {
        dateFormat = new SimpleDateFormat(pattern);
    }

    public DateCellRenderer(String pattern, Locale locale) {
        dateFormat = new SimpleDateFormat(pattern, locale);
    }

    public DateCellRenderer(String pattern, DateFormatSymbols symbols) {
        dateFormat = new SimpleDateFormat(pattern, symbols);
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
    public Component getTableCellRendererComponent(JTable jTable, Object value,
            boolean isSelected, boolean hasFocus, int row, int column) {

        Component c = super.getTableCellRendererComponent(jTable, value,
                isSelected, hasFocus, row, column);

        if (c instanceof JLabel && value instanceof Calendar) {
            JLabel label = (JLabel) c;
            label.setHorizontalAlignment(JLabel.RIGHT);
            
            GregorianCalendar date = (GregorianCalendar) value;
            String text = dateFormat.format(date.getTime());
            label.setText(text);
        }

        return c;
    }

    /**
     * Gets the date format used by this cell renderer when formatting values.
     *
     * @return the date format
     */
    public SimpleDateFormat getDateFormat() {
        return dateFormat;
    }

    /**
     * Sets the date format used by this cell renderer when formatting values.
     *
     * @param newDateFormat the date format
     */
    public void setDateFormat(SimpleDateFormat newDateFormat) {
        dateFormat = newDateFormat;
    }

}
