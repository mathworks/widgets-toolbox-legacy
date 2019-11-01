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

import java.util.Vector;
import javax.swing.event.TableModelEvent;

/**
 * A subclass of TableModel for storing data, with a method for extracting the data by row or by column.
 */
public class TableModel extends javax.swing.table.DefaultTableModel {

    protected Vector<Vector<Boolean>> modified = new Vector<Vector<Boolean>>();
    protected Vector<Boolean> editable = new Vector<Boolean>();
    
    /**
     * Constructs a default TableModel which is a table of zero columns and zero rows.
     */
    public TableModel() {

        super(); // call superclass constructor
        this.addTableModelListener(new Listener()); // listen for changes

    }
    
    /**
     * Constructs a TableModel with rowCount and columnCount of null object values.
     * 
     * @param rowCount the number of rows
     * 
     * @param columnCount the number of columns
     */
    public TableModel(int rowCount, int columnCount) {

        super(rowCount, columnCount); // call superclass constructor
        this.addTableModelListener(new Listener()); // listen for changes

    }

    /**
     * Constructs a TableModel and initializes the table by passing data and columnNames to the setDataVector method.
     * 
     * @param data the data
     * 
     * @param columnNames the column names
     */
    public TableModel(Object[][] data, Object[] columnNames) {

        super(data, columnNames); // call superclass constructor
        this.addTableModelListener(new Listener()); // listen for changes
    }

    /**
     * Constructs a TableModel with as many columns as there are elements in columnNames and rowCount of null object values.
     * 
     * @param columnNames the column names
     * 
     * @param rowCount the number of rows
     */
    public TableModel(Object[] columnNames, int rowCount) {

        super(columnNames, rowCount); // call superclass constructor
        this.addTableModelListener(new Listener()); // listen for changes

    }

    /**
     * Constructs a TableModel with as many columns as there are elements in columnNames and rowCount of null object values.
     * 
     * @param columnNames the column names
     * 
     * @param rowCount the number of rows
     */
    public TableModel(Vector columnNames, int rowCount) {

        super(columnNames, rowCount); // call superclass constructor
        this.addTableModelListener(new Listener()); // listen for changes

    }
    
    /**
     * Constructs a TableModel and initializes the table by passing data and columnNames to the setDataVector method.
     * 
     * @param data the data
     * 
     * @param columnNames the column names
     */

    public TableModel(Vector data, Vector columnNames) {

        super(data, columnNames); // call superclass constructor
        this.addTableModelListener(new Listener()); // listen for changes

    }

    /**
     * Returns the Vector of Vectors that contains the table's data values.
     * 
     * @param isByRow true for data arranged by row and then by column, false for data arranged by column and then by row
     * 
     * @return the table data
     */
    public Vector getDataVector(boolean isByRow) {

        Vector byRow = this.getDataVector();
        if (isByRow) {
            return byRow;
        } else {
            if (byRow.isEmpty()) {
                return new Vector();
            } else {
                int nRows = byRow.size();
                Vector firstRow = (Vector) byRow.elementAt(0);
                int nColumns = firstRow.size();
                Vector<Vector> byColumn = new Vector<Vector>(nColumns);
                for (int cc = 0; cc < nColumns; cc++) {
                    Vector<Object> thisColumn = new Vector<Object>(nRows);
                    for (int rr = 0; rr < nRows; rr++) {
                        thisColumn.addElement(((Object) ((Vector) byRow.elementAt(rr)).elementAt(cc)));
                    }
                    byColumn.addElement(thisColumn);
                }
                return byColumn;
            }
        }
    }
    
    /**
     * Returns the Vector of Vectors that contains the modified flags for the table's data values.
     * 
     * @return the modified flags for the table data
     */
    public Vector isModified() {

        return modified;

    }
    
    /**
     * Returns true for a modified cell, and false otherwise.
     * 
     * @param row the row
     * 
     * @param column the column
     * 
     * @return true for a modified cell, false otherwise
     */
    public boolean isCellModified(int row, int column) {
        
        if (this.getRowCount() > row && this.getColumnCount() > column) {
            return modified.elementAt(row).elementAt(column).booleanValue();
        } else {
            return false;
        }
    }

    /**
     * Returns the Vector that contains the editable flags for the table's data values.
     * 
     * @return the editable flags for the table data
     */
    public Vector isEditable() {

        return editable;

    }
    
    /**
     * Sets the Vector that contains the editable flags for the table's data values.
     * 
     * @param newEditable the editable flags for the table data
     */
    public void setEditable(Vector<Boolean> newEditable) {
        
        if (newEditable.size() != editable.size()) {
            throw new RuntimeException("Incorrect size");
        }

        editable = newEditable;

    }
    
    
    /**
     * Returns true for an editable cell, and false otherwise.
     * 
     * @param row the row
     * 
     * @param column the column
     * 
     * @return true for an editable cell, false otherwise
     */
    @Override
    public boolean isCellEditable(int row, int column) {

        return editable.elementAt(column).booleanValue();

    }
    
    /**
     * Accepts all changes.
     */
    public void commit() {
            int nRows = this.getRowCount();
            int nColumns = this.getColumnCount();
        modified = new Vector<Vector<Boolean>>();
        for (int rr = 0; rr < nRows; rr++) {
            Vector<Boolean> thisRow = new Vector<Boolean>();
            for (int cc = 0; cc < nColumns; cc++) {
                thisRow.add(false);
            }
            modified.add(rr, thisRow);
        }
    }
    
    private class Listener implements javax.swing.event.TableModelListener {

        /**
         * Callback for changes in cells, rows, or columns.
         * 
         * @param e event data
         */
        @Override
        public void tableChanged(TableModelEvent e) {

            int firstRow = e.getFirstRow();
            int lastRow = e.getLastRow();
            int nRows = TableModel.this.getRowCount();
            int column = e.getColumn();
            int nColumns = TableModel.this.getColumnCount();

            switch (e.getType()) {
                case TableModelEvent.INSERT:
                    // Rows [firstRow,lastRow] have been inserted
                    Vector<Boolean> thisRow = new Vector<Boolean>();
                    for (int rr = firstRow; rr <= lastRow; rr++) {
                        for (int cc = 0; cc < nColumns; cc++) {
                            thisRow.add(false);
                        }
                        modified.add(rr, thisRow);
                    }
                    break;
                case TableModelEvent.UPDATE:
                    if (firstRow == TableModelEvent.HEADER_ROW) {
                        // Everything has changed
                        modified = new Vector<Vector<Boolean>>();
                        for (int rr = 0; rr < nRows; rr++) {
                            thisRow = new Vector<Boolean>();
                            for (int cc = 0; cc < nColumns; cc++) {
                                thisRow.add(false);
                            }
                            modified.add(rr, thisRow);
                        }
                        editable = new Vector<Boolean>();
                        for (int cc = 0; cc < nColumns; cc++) {
                            editable.add(true);
                        }
                    } else if (firstRow == 0 && lastRow == Integer.MAX_VALUE) {
                        // The column structure has remained the same, but the
                        // number of the rows and their contents have changed
                        modified = new Vector<Vector<Boolean>>();
                        for (int rr = 0; rr < nRows; rr++) {
                            thisRow = new Vector<Boolean>();
                            for (int cc = 0; cc < nColumns; cc++) {
                                thisRow.add(false);
                            }
                            modified.add(rr, thisRow);
                        }
                    } else if (column == TableModelEvent.ALL_COLUMNS) {
                        // Complete rows in [firstRow,lastRow] have changed
                        for (int rr = firstRow; rr <= lastRow; rr++) {
                            for (int cc = 0; cc < nColumns; cc++) {
                                modified.elementAt(rr).setElementAt(true, cc);
                            }
                        }
                    } else if (column != TableModelEvent.ALL_COLUMNS) {
                        // One column in [firstRow,lastRow] has changed
                        for (int rr = firstRow; rr <= lastRow; rr++) {
                            modified.elementAt(rr).setElementAt(true, column);
                        }
                    }
                    break;
                case TableModelEvent.DELETE:
                    // Rows [firstRow,lastRow] have been removed
                    for (int rr = lastRow; rr >= firstRow; rr--) {
                        modified.removeElementAt(rr);
                    }
                    break;
            }

        }
    }
}
