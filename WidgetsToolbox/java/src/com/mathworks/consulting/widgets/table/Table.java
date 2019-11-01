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
import javax.swing.JComponent;
import javax.swing.table.TableColumn;
import javax.swing.table.TableModel;
import javax.swing.table.TableColumnModel;
import javax.swing.table.TableCellRenderer;
import javax.swing.ListSelectionModel;
import com.jidesoft.grid.SortableTable;
import com.jidesoft.grid.SortableTableModel;
import com.jidesoft.grid.TableModelWrapper;
import com.jidesoft.grid.RowTableModelWrapper;
import com.jidesoft.grid.ColumnTableModelWrapper;
import java.awt.Color;

/**
 * A subclass of TableModel for storing data, with a method for extracting the data by row or by column.
 */
public class Table extends SortableTable {
    
    private Color unmodifiedCellColor = Color.WHITE;
    private Color modifiedCellColor = Color.WHITE;
    public Color[][] cellColors = null;

    public Table() {

        super();

    }

    public Table(int numRows, int numColumns) {

        super(numRows, numColumns);

    }

    public Table(Object[][] rowData, Object[] columnNames) {

        super(rowData, columnNames);

    }

    public Table(TableModel model) {

        super(model);

    }

    public Table(TableModel dm, TableColumnModel cm) {

        super(dm, cm);

    }

    public Table(TableModel dm, TableColumnModel cm, ListSelectionModel sm) {

        super(dm, cm, sm);

    }

    public Table(Vector rowData, Vector columnNames) {

        super(rowData, columnNames);

    }
    
    public boolean setColumnCount(int newNumCol, boolean flagRemove)
    {
        //int idx;
        
        
        // Get table model
        //TableModel tableModel = this.getModel();
        //com.jidesoft.grid.SortableTableModel tableModel = 
        //        (com.jidesoft.grid.SortableTableModel) this.getModel();
        com.mathworks.consulting.widgets.table.TableModel tableModel = 
                (com.mathworks.consulting.widgets.table.TableModel) 
                ( (com.jidesoft.grid.SortableTableModel) this.getModel() ).getActualModel();
        
        
        // Get column model
        TableColumnModel colModel = this.getColumnModel();
        int oldNumCol = colModel.getColumnCount();
        
        // Do we need to add or remove columns?
        if (newNumCol > oldNumCol) {
            // Add more columns
            tableModel.setColumnCount(newNumCol);
            for (int idx=oldNumCol+1; idx <= newNumCol; idx++)  {
                colModel.addColumn( new TableColumn(idx-1,100) );
            }
            return true;
        }
        else if ((newNumCol < oldNumCol) && flagRemove ) {
            // Remove columns
            for (int idx=oldNumCol; idx > newNumCol; idx--)  {
                colModel.removeColumn( colModel.getColumn(idx-1) );
            }
            tableModel.setColumnCount(newNumCol);
            return true;
        }
        
            return false;

    } 
    
    public Color getUnmodifiedCellColor() {
        return unmodifiedCellColor;
    }
    
    public void setUnmodifiedCellColor(Color color) {
        unmodifiedCellColor = color;
    }
    
    public Color getModifiedCellColor() {
        return modifiedCellColor;
    }
    
    public void setModifiedCellColor(Color color) {
        modifiedCellColor = color;
    }
    
    public void setCellColor(int rowIndex, int columnIndex, Color color) {
        // Size colors array if not set
        if (this.cellColors==null){
            this.cellColors = new Color[this.getRowCount()][this.getColumnCount()];
        }
        // Resize colors array if necessary
        if(rowIndex<this.getRowCount()) {
            Color[][] oldColors = this.cellColors;
            this.cellColors = new Color[this.getRowCount()][this.getColumnCount()];
            // populate new array with old values
            for (int i=0;i<oldColors.length;i++){
                for (int j=0;j<oldColors[i].length;j++){
                    this.cellColors[i][j] = oldColors[i][j];
                }
            }
        }
        this.cellColors[rowIndex-1][columnIndex-1] = color;
    }
    
    @Override
    public TableCellRenderer getCellRenderer(int row, int column) {

        // Get standard cell renderer        
        TableCellRenderer tableCellRenderer = super.getCellRenderer(row, column);

        // Convert to model coordinates
        row = this.convertRowIndexToModel(row);
        column = this.convertColumnIndexToModel(column);

        // Get table model
        TableModel tableModel = this.getModel();

        // For wrapped table models, find the actual table model
        while (tableModel instanceof TableModelWrapper) {
            if (tableModel instanceof RowTableModelWrapper) {
                row = ((RowTableModelWrapper) tableModel).getActualRowAt(row);
            }
            if (tableModel instanceof ColumnTableModelWrapper) {
                column = ((ColumnTableModelWrapper) tableModel).getActualColumnAt(column);
            }
            tableModel = ((TableModelWrapper) tableModel).getActualModel();
        }

        // Is cell modified?
        boolean modified;
        if (tableModel instanceof com.mathworks.consulting.widgets.table.TableModel) {
            modified = ((com.mathworks.consulting.widgets.table.TableModel) tableModel).isCellModified(row, column);
        } else {
            modified = false;
        }

        // Adjust cell renderer
        if (tableCellRenderer instanceof JComponent) {
            if (modified) {
                ((JComponent) tableCellRenderer).setBackground(modifiedCellColor);
            } else {
                ((JComponent) tableCellRenderer).setBackground(unmodifiedCellColor);
            }
        }
        
        // If a specific color for the cell has been set, use it
        if (this.cellColors != null) {
            if (row <= this.cellColors.length) {
                if (column <= this.cellColors[row].length) {
                    Color color = this.cellColors[row][column];
                    if (color != null) {
                        ((JComponent) tableCellRenderer).setBackground(color);
                    }
                }
            }
        }
        return tableCellRenderer;

    }
    
}
