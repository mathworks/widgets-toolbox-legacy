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
package com.mathworks.consulting.widgets;

import java.util.Calendar;

/**
 * A package for utility functions, e.g., datatype identification and conversion.
 */
public class Utilities {

    private Utilities() {
    } // no constructor

    /**
     * Returns true for logical arrays.
     *
     * @param objects the objects
     *
     * @return true or false
     */
    public static boolean islogical(Object[] objects) {
        for (Object object : objects) {
            if (!(object instanceof Boolean)) {
                return false;
            }
        }
        return true;
    }

    /**
     * Returns true for integer arrays.
     *
     * @param objects the objects
     *
     * @return true or false
     */
    public static boolean isinteger(Object[] objects) {
        if (objects == null) {
            return false;
        } else {
            for (Object object : objects) {
                if (!(object instanceof Integer)) {
                    return false;
                }
            }
            return true;
        }
    }

    /**
     * Returns true for double arrays.
     *
     * @param objects the objects
     *
     * @return true or false
     */
    public static boolean isdouble(Object[] objects) {
        if (objects == null) {
            return false;
        } else {
            for (Object object : objects) {
                if (!(object instanceof Double)) {
                    return false;
                }
            }
            return true;
        }
    }

    /**
     * Returns true for date arrays.
     *
     * @param objects the objects
     *
     * @return true or false
     */
    public static boolean isdate(Object[] objects) {
        if (objects == null) {
            return false;
        } else {
            for (Object object : objects) {
                if (!(object instanceof Calendar)) {
                    return false;
                }
            }
            return true;
        }
    }

    /**
     * Returns true for string arrays.
     *
     * @param objects the objects
     *
     * @return true or false
     */
    public static boolean iscellstr(Object[] objects) {
        if (objects == null) {
            return false;
        } else {
            for (Object object : objects) {
                if (!( (object == null) || (object instanceof Character) || (object instanceof String) )) {
                    return false;
                }
            }
            return true;
        }
    }

    /**
     * Casts an object array to a logical array.
     *
     * @param objects the objects
     *
     * @return the array of logicals
     */
    public static boolean[] object2logical(Object[] objects) {
        if (objects == null) {
            return new boolean[0];
        } else {
            boolean[] booleans = new boolean[objects.length];
            for (int ii = 0; ii < objects.length; ii++) {
                booleans[ii] = ((Boolean) objects[ii]);
            }
            return booleans;
        }
    }

    /**
     * Casts an object array to an integer array.
     *
     * @param objects the objects
     *
     * @return the array of integers
     */
    public static int[] object2integer(Object[] objects) {
        if (objects == null) {
            return new int[0];
        } else {
            int[] ints = new int[objects.length];
            for (int ii = 0; ii < objects.length; ii++) {
                ints[ii] = ((Integer) objects[ii]).intValue();
            }
            return ints;
        }
    }

    /**
     * Casts an object array to a double array.
     *
     * @param objects the objects
     *
     * @return the array of doubles
     */
    public static double[] object2double(Object[] objects) {
        if (objects == null) {
            return new double[0];
        } else {
            double[] doubles = new double[objects.length];
            for (int ii = 0; ii < objects.length; ii++) {
                if (objects[ii] == null) {
                    doubles[ii] = Double.NaN;
                } else {
                    doubles[ii] = ((Double) objects[ii]);
                }
            }
            return doubles;
        }
    }

    /**
     * Casts an object array to a datenum array.
     *
     * @param objects the objects
     *
     * @return the array of datenum
     */
    public static double[] object2datenum(Object[] objects) {
        if (objects == null) {
            return new double[0];
        } else {
            double[] doubles = new double[objects.length];
            for (int ii = 0; ii < objects.length; ii++) {
                Calendar object = ((Calendar) objects[ii]);
                if (object == null) {
                    doubles[ii] = Double.NaN;
                } else {
                    Long date = object.getTimeInMillis();
                    Long offset = new Long(object.getTimeZone().getOffset(date));
                    doubles[ii] = (date.doubleValue() + offset.doubleValue()) / 86400000. + 719529.;
                }
            }
            return doubles;
        }
    }

    /**
     * Casts an object to a string.
     *
     * @param object the object
     *
     * @return the string
     */
    public static String object2string(Object object) {
        if (object == null) {
            return new String();
        } else {
            return object.toString();
        }
    }

    /**
     * Casts an object array to a string array.
     *
     * @param objects the objects
     *
     * @return the array of strings
     */
    public static String[] object2string(Object[] objects) {
        if (objects == null) {
            return new String[0];
        } else {
            String[] strings = new String[objects.length];
            for (int ii = 0; ii < objects.length; ii++) {
                if (objects[ii] == null) {
                    strings[ii] = new String();
                } else {
                    strings[ii] = objects[ii].toString();
                }
            }
            return strings;
        }
    }
}
