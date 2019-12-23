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

package com.mathworks.consulting.widgets;

import java.awt.datatransfer.*;
import java.awt.dnd.*;
import java.io.IOException;

public class DropTarget extends java.awt.dnd.DropTarget {

    private String contentType;
    private Transferable transferable;
    private String transferData;
    private DataFlavor[] flavors;

    @Override
    public synchronized void dragEnter(DropTargetDragEvent evt) {

        transferable = evt.getTransferable();
        flavors = (DataFlavor[]) transferable.getTransferDataFlavors();
        try {
            if (flavors.length > 0 && transferable.isDataFlavorSupported(flavors[0])) {
                contentType = flavors[0].getHumanPresentableName();
                transferData = transferable.getTransferData(flavors[0]).toString();
            }
        } catch (UnsupportedFlavorException | IOException e) {
        } finally {
            super.dragEnter(evt);
        }

    }

    @Override
    public synchronized void drop(DropTargetDropEvent evt) {

        // Make sure drop is accepted
        evt.acceptDrop(DnDConstants.ACTION_COPY_OR_MOVE);

        transferable = evt.getTransferable();
        flavors = (DataFlavor[]) transferable.getTransferDataFlavors();

        try {
            if (flavors.length > 0 && transferable.isDataFlavorSupported(flavors[0])) {
                contentType = flavors[0].getHumanPresentableName();
                transferData = transferable.getTransferData(flavors[0]).toString();
            }
        } catch (UnsupportedFlavorException | IOException e) {
        } finally {
            super.drop(evt);
        }

    }
    
    public String getContentType() {
        return contentType;
    }

    public Transferable getTransferable() {
        return transferable;
    }

    public String getTransferData() {
        return transferData;
    }
}
